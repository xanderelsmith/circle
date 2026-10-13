import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:circle_flutter/firebase_options.dart';
import 'package:circle_flutter/client.dart';
import 'package:circle_flutter/services/notification_service.dart';
import 'dart:developer';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final NotificationService backgroundNotificationService = NotificationService();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling background message: ${message.messageId}');

  await backgroundNotificationService.initialize();
  if (message.notification != null || message.data.isNotEmpty) {
    final title = message.notification?.title ?? message.data['title'] ?? 'Notification';
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
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();
  String? _currentToken;
  bool _isInitialized = false;
  GlobalKey<NavigatorState>? _navigatorKey;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    if (_isInitialized) return;

    _navigatorKey = navigatorKey;

    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('User granted provisional notification permission');
      } else {
        log('User declined or has not accepted notification permission');
      }

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      await _getToken();
      _messaging.onTokenRefresh.listen(_onTokenRefresh);
      await subscribeToTopic('all_users');

      _isInitialized = true;
      log('PushNotificationService initialized successfully');
    } catch (e) {
      log('Error initializing PushNotificationService: $e');
    }
  }

  Future<void> _getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
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

  void _onTokenRefresh(String token) {
    log('FCM Token refreshed: $token');
    _currentToken = token;
    sendTokenToServer(token);
  }

  Future<void> sendTokenToServer(String token) async {
    try {
      final platform = Platform.isAndroid ? 'android' : 'ios';
      await client.notification.registerDeviceToken(token, platform);
      log('Successfully sent token to server: $token (platform: $platform)');
    } catch (e) {
      log('Error sending token to server: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    log('Received foreground message:');
    log('  Title: ${message.notification?.title}');
    log('  Body: ${message.notification?.body}');
    log('  Data: ${message.data}');

    if (message.notification != null) {
      final title = message.notification?.title ?? message.data['title'] ?? 'Notification';
      final body = message.notification?.body ?? message.data['body'] ?? '';
      _showLocalNotification(title: title, body: body, data: message.data);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    log('Message opened app:');
    log('  Data: ${message.data}');
    _navigateFromData(message.data);
  }

  Future<void> _showLocalNotification({
    required String title, required String body, Map<String, dynamic>? data,
  }) async {
    try {
      await _notificationService.sendFcmNotification(title: title, body: body, data: data);
    } catch (e) {
      log('Error showing local notification: $e');
    }
  }

  void _navigateFromData(Map<String, dynamic> data) {
    final String? route = data['route'];
    final String? type = data['type'];

    if (route != null) { _navigateToRoute(route); }

    if (type != null) {
      switch (type) {
        case 'streak_reminder': case 'deadline_reminder': case 'streak_achieved':
          _navigateToCircle(data['circleName'] ?? ''); break;
        case 'proof_posted': case 'interaction':
          _navigateToActivityThread(data['circleName'] ?? ''); break;
        case 'weekly_summary': _navigateToProfile(); break;
        default: log('Unknown notification type: $type');
      }
    }
  }

  void _navigateToRoute(String route) {
    final navigator = _navigatorKey?.currentState;
    if (navigator != null) { navigator.pushNamed(route); }
  }

  void _navigateToCircle(String circleName) {
    final navigator = _navigatorKey?.currentState;
    if (navigator != null) { navigator.pushNamed('/circles'); }
  }

  void _navigateToActivityThread(String circleName) {
    final navigator = _navigatorKey?.currentState;
    if (navigator != null) { navigator.pushNamed('/circles'); }
  }

  void _navigateToProfile() {
    final navigator = _navigatorKey?.currentState;
    if (navigator != null) { navigator.pushNamed('/profile'); }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) { log('Error subscribing to topic: $e'); }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) { log('Error unsubscribing from topic: $e'); }
  }

  Future<void> subscribeToCircle(int circleId) async { await subscribeToTopic('circle_$circleId'); }
  Future<void> unsubscribeFromCircle(int circleId) async { await unsubscribeFromTopic('circle_$circleId'); }

  String? get currentToken => _currentToken;
  bool get isInitialized => _isInitialized;
}