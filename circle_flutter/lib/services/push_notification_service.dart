import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:circle_flutter/firebase_options.dart';
import 'package:circle_flutter/client.dart';
import 'package:circle_flutter/services/notification_service.dart';
import 'dart:developer';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final NotificationService backgroundNotificationService =
      NotificationService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');

  await backgroundNotificationService.initialize();
  if (message.notification != null || message.data.isNotEmpty) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    final data = message.data;

    await backgroundNotificationService.sendFcmNotification(
      title: title,
      body: body,
      data: data,
    );
  }
}

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();
  String? _currentToken;
  bool _isInitialized = false;

  /// Initialize push notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted notification permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('User granted provisional notification permission');
      } else {
        log('User declined or has not accepted notification permission');
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle notification taps when app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Get and store FCM token
      await _getToken();

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      // Subscribe to all_users topic
      await subscribeToTopic('all_users');

      _isInitialized = true;
      log('PushNotificationService initialized successfully');
    } catch (e) {
      log('Error initializing PushNotificationService: $e');
    }
  }

  /// Get FCM token
  Future<void> _getToken() async {
    try {
      // For iOS, get APNs token first
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          // Wait a bit and try again - APNs token might not be ready immediately
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
        }
        log('APNs Token: $apnsToken');
      }

      _currentToken = await _messaging.getToken();
      if (_currentToken != null) {
        log('FCM Token: $_currentToken');
        await sendTokenToServer(_currentToken!);
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String token) {
    log('FCM Token refreshed: $token');
    _currentToken = token;
    sendTokenToServer(token);
  }

  /// Send token to server for storing
  Future<void> sendTokenToServer(String token) async {
    try {
      // Get the platform
      final platform = Platform.isAndroid ? 'android' : 'ios';

      // Send token to Serverpod server
      await client.notification.registerDeviceToken(token, platform);

      log('Successfully sent token to server: $token (platform: $platform)');
    } catch (e) {
      log('Error sending token to server: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    log('Received foreground message:');
    log('  Title: ${message.notification?.title}');
    log('  Body: ${message.notification?.body}');
    log('  Data: ${message.data}');

    // Show local notification when app is in foreground
    if (message.notification != null) {
      final title =
          message.notification?.title ??
          message.data['title'] ??
          'Notification';
      final body = message.notification?.body ?? message.data['body'] ?? '';

      _showLocalNotification(title: title, body: body, data: message.data);
    }
  }

  /// Handle when user taps notification to open app
  void _handleMessageOpenedApp(RemoteMessage message) {
    log('Message opened app:');
    log('  Data: ${message.data}');

    // Navigate based on message data
    handleNotificationNavigation(message.data);
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Use a unique ID based on current time
      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _notificationService.sendFcmNotification(
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  /// Handle navigation based on notification data
  void handleNotificationNavigation(Map<String, dynamic> data) {
    // Extract navigation info from data
    final String? route = data['route'];
    final String? type = data['type'];

    if (route != null) {
      // Navigation would be handled by the app's router
      log('Should navigate to: $route');
    }

    if (type != null) {
      switch (type) {
        case 'streak_reminder':
          log('Navigate to circle: ${data['circleName']}');
          break;
        case 'deadline_reminder':
          log('Navigate to circle: ${data['circleName']}');
          break;
        case 'streak_achieved':
          log('Navigate to circle: ${data['circleName']}');
          break;
        case 'proof_posted':
          log('Navigate to activity thread: ${data['circleName']}');
          break;
        case 'interaction':
          log('Navigate to activity thread: ${data['circleName']}');
          break;
        case 'weekly_summary':
          log('Navigate to profile/leaderboard');
          break;
        default:
          log('Unknown notification type: $type');
      }
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to circle-specific topic
  Future<void> subscribeToCircle(int circleId) async {
    await subscribeToTopic('circle_$circleId');
  }

  /// Unsubscribe from circle-specific topic
  Future<void> unsubscribeFromCircle(int circleId) async {
    await unsubscribeFromTopic('circle_$circleId');
  }

  /// Get current FCM token
  String? get currentToken => _currentToken;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}