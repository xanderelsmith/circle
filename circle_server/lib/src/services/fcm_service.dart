import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../generated/device_token.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static FCMService? _instance;
  static FCMService get instance => _instance ??= FCMService._();
  FCMService._();

  String? _projectId;
  String? _accessToken;
  DateTime? _tokenExpiry;

  /// Initialize with project ID (from service account or environment)
  Future<void> initialize({String? projectId}) async {
    _projectId = projectId ?? Platform.environment['FIREBASE_PROJECT_ID'];
    print('FCM Service initialized with project: $_projectId');
  }

  /// Get OAuth2 access token for FCM API
  Future<String> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiry != null && _tokenExpiry!.isAfter(DateTime.now())) {
      return _accessToken!;
    }

    try {
      // Try to get token from gcloud (if running on Google Cloud)
      final result = await Process.run('gcloud', ['auth', 'application-default', 'print-access-token']);
      if (result.exitCode == 0) {
        _accessToken = result.stdout.toString().trim();
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 55));
        return _accessToken!;
      }
    } catch (_) {}

    try {
      // Try to get from service account file
      final saPath = Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'] ?? 
                     Platform.environment['FIREBASE_SERVICE_ACCOUNT_PATH'];
      if (saPath != null && File(saPath).existsSync()) {
        final saJson = jsonDecode(await File(saPath).readAsString());
        _accessToken = await _getTokenFromServiceAccount(saJson);
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 55));
        return _accessToken!;
      }
    } catch (_) {}

    try {
      // Try service account JSON from env
      final saJsonStr = Platform.environment['FIREBASE_SERVICE_ACCOUNT_JSON'];
      if (saJsonStr != null) {
        final saJson = jsonDecode(saJsonStr);
        _accessToken = await _getTokenFromServiceAccount(saJson);
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 55));
        return _accessToken!;
      }
    } catch (_) {}

    throw Exception('Could not obtain FCM access token. Set GOOGLE_APPLICATION_CREDENTIALS or FIREBASE_SERVICE_ACCOUNT_PATH/JSON');
  }

  Future<String> _getTokenFromServiceAccount(Map<String, dynamic> sa) async {
    final client = http.Client();
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final claim = {
        'iss': sa['client_email'],
        'scope': 'https://www.googleapis.com/auth/firebase.messaging',
        'aud': 'https://oauth2.googleapis.com/token',
        'exp': now + 3600,
        'iat': now,
      };

      // In production, you'd use a proper JWT library
      // For now, return a placeholder - replace with actual JWT signing
      final response = await client.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': '', // Would need proper JWT signing here
        },
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['access_token'];
      }
      
      throw Exception('Failed to get token: ${response.body}');
    } finally {
      client.close();
    }
  }

  /// Send notification to a specific device token using FCM v1 API
  Future<bool> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    if (_projectId == null) {
      print('FCM not configured (no project ID)');
      return false;
    }

    try {
      final accessToken = await _getAccessToken();
      final client = http.Client();

      try {
        final message = {
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
              if (imageUrl != null) 'image': imageUrl,
            },
            'data': data?.map((k, v) => MapEntry(k, v)) ?? {},
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'general_notifications',
                'icon': 'ic_notification',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'alert': {'title': title, 'body': body},
                  'sound': 'default',
                  'badge': 1,
                },
              },
            },
          },
        };

        final response = await client.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          print('FCM sent successfully to token');
          return true;
        } else {
          print('FCM error: ${response.statusCode} - ${response.body}');
          return false;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error sending FCM to token: $e');
      return false;
    }
  }

  /// Send notification to multiple tokens (using batch send)
  Future<int> sendToTokens({
    required List<String> tokens,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    if (_projectId == null || tokens.isEmpty) return 0;

    int successCount = 0;
    // FCM v1 doesn't have batch send, send individually
    // In production, consider using Firebase Admin SDK's sendEachForMulticast
    for (final token in tokens) {
      final success = await sendToToken(
        token: token,
        title: title,
        body: body,
        data: data,
        imageUrl: imageUrl,
      );
      if (success) successCount++;
      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return successCount;
  }

  /// Send notification to a topic
  Future<bool> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    if (_projectId == null) return false;

    try {
      final accessToken = await _getAccessToken();
      final client = http.Client();

      try {
        final message = {
          'message': {
            'topic': topic,
            'notification': {
              'title': title,
              'body': body,
              if (imageUrl != null) 'image': imageUrl,
            },
            'data': data?.map((k, v) => MapEntry(k, v)) ?? {},
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'general_notifications',
                'icon': 'ic_notification',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'alert': {'title': title, 'body': body},
                  'sound': 'default',
                  'badge': 1,
                },
              },
            },
          },
        };

        final response = await client.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(message),
        );

        return response.statusCode == 200;
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error sending FCM to topic: $e');
      return false;
    }
  }

  /// Subscribe tokens to a topic
  Future<void> subscribeToTopic({
    required List<String> tokens,
    required String topic,
  }) async {
    if (_projectId == null || tokens.isEmpty) return;

    try {
      final accessToken = await _getAccessToken();
      final client = http.Client();

      try {
        final response = await client.post(
          Uri.parse('https://iid.googleapis.com/iid/v1:batchAdd'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'to': '/topics/$topic',
            'registration_tokens': tokens,
          }),
        );

        if (response.statusCode != 200) {
          print('Subscribe to topic error: ${response.body}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe tokens from a topic
  Future<void> unsubscribeFromTopic({
    required List<String> tokens,
    required String topic,
  }) async {
    if (_projectId == null || tokens.isEmpty) return;

    try {
      final accessToken = await _getAccessToken();
      final client = http.Client();

      try {
        final response = await client.post(
          Uri.parse('https://iid.googleapis.com/iid/v1:batchRemove'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'to': '/topics/$topic',
            'registration_tokens': tokens,
          }),
        );

        if (response.statusCode != 200) {
          print('Unsubscribe from topic error: ${response.body}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Send notification to a user by looking up their device tokens
  Future<bool> sendToUser({
    required Session session,
    required int userId,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    try {
      final tokens = await DeviceToken.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (tokens.isEmpty) {
        print('No device tokens found for user $userId');
        return false;
      }

      final tokenList = tokens.map((t) => t.token).toList();
      final successCount = await sendToTokens(
        tokens: tokenList,
        title: title,
        body: body,
        data: data,
        imageUrl: imageUrl,
      );

      return successCount > 0;
    } catch (e) {
      print('Error sending FCM to user: $e');
      return false;
    }
  }
}