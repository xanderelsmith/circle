import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import 'dart:convert';
import 'package:circle_flutter/client.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _streakReminderKey = 'streak_reminder_enabled';
  static const String _deadlineReminderKey = 'deadline_reminder_enabled';
  static const String _firstLaunchKey = 'first_launch_complete';

  // Initialize notification service
  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Request notification permission (only needed for Android 13+)
    if (Platform.isAndroid) {
      try {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        // Request exact alarm permission for Android 12+ (API 31+)
        final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
        if (exactAlarmStatus.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      } catch (e) {
        // Permission might not be available on older Android versions
      }
    }

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Initialization settings for both platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  // Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel streakChannel = AndroidNotificationChannel(
      'streak_reminders',
      'Streak Reminders',
      description: 'Daily reminders to maintain your streak',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel deadlineChannel =
        AndroidNotificationChannel(
          'deadline_reminders',
          'Deadline Reminders',
          description: 'Reminders for circle daily deadlines',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
          'general_notifications',
          'General Notifications',
          description: 'General app notifications',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: true,
        );

    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.createNotificationChannel(streakChannel);
    await androidImpl?.createNotificationChannel(deadlineChannel);
    await androidImpl?.createNotificationChannel(generalChannel);
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        // Navigation handled by PushNotificationService
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  // Check and send first app launch notification
  Future<void> sendFirstLaunchNotification() async {
    // Implementation if needed
  }

  // Send streak reminder notification
  Future<void> sendStreakReminder({
    required String circleName,
    required int currentStreak,
    required String deadlineTime,
  }) async {
    try {
      // Check if streak reminders are enabled
      // For now, we'll just show it

      await _showNotification(
        id: 100,
        title: '🔥 Keep Your Streak Alive!',
        body:
            'Your $currentStreak-day streak in "$circleName" needs attention. Deadline: $deadlineTime',
        channelId: 'streak_reminders',
        payload: jsonEncode({
          'type': 'streak_reminder',
          'circleName': circleName,
        }),
      );
    } catch (e) {
      debugPrint('Error sending streak reminder: $e');
    }
  }

  // Send deadline reminder notification
  Future<void> sendDeadlineReminder({
    required String circleName,
    required String deadlineTime,
    required int hoursUntilDeadline,
  }) async {
    try {
      String title;
      String body;

      if (hoursUntilDeadline <= 1) {
        title = '⚠️ Deadline Approaching!';
        body =
            'Only $hoursUntilDeadline hour left for "$circleName" deadline at $deadlineTime!';
      } else if (hoursUntilDeadline <= 3) {
        title = '⏰ Deadline Soon';
        body =
            '$hoursUntilDeadline hours until "$circleName" deadline at $deadlineTime';
      } else {
        title = '📅 Daily Reminder';
        body =
            'Don\'t forget to post your proof for "$circleName" by $deadlineTime';
      }

      await _showNotification(
        id: 101,
        title: title,
        body: body,
        channelId: 'deadline_reminders',
        payload: jsonEncode({
          'type': 'deadline_reminder',
          'circleName': circleName,
        }),
      );
    } catch (e) {
      debugPrint('Error sending deadline reminder: $e');
    }
  }

  // Send streak achieved notification
  Future<void> sendStreakAchievedNotification({
    required String circleName,
    required int streakDays,
  }) async {
    try {
      String title;
      String body;

      if (streakDays >= 30) {
        title = '🏆 Legendary Streak!';
        body = 'Incredible! $streakDays days straight in "$circleName"!';
      } else if (streakDays >= 14) {
        title = '💪 Two Week Streak!';
        body = '$streakDays days in "$circleName" - you\'re on fire!';
      } else if (streakDays >= 7) {
        title = '🌟 Week Streak Achieved!';
        body = '7 days strong in "$circleName"! Keep it going!';
      } else {
        title = '✨ Streak Updated';
        body = '$streakDays day streak in "$circleName"';
      }

      await _showNotification(
        id: 102,
        title: title,
        body: body,
        channelId: 'general_notifications',
        payload: jsonEncode({
          'type': 'streak_achieved',
          'circleName': circleName,
          'streakDays': streakDays,
        }),
      );
    } catch (e) {
      debugPrint('Error sending streak achieved notification: $e');
    }
  }

  // Send proof posted notification (to circle members)
  Future<void> sendProofPostedNotification({
    required String authorName,
    required String circleName,
    required String activityTitle,
  }) async {
    try {
      await _showNotification(
        id: 103,
        title: '$authorName posted proof!',
        body: '$activityTitle in "$circleName"',
        channelId: 'general_notifications',
        payload: jsonEncode({
          'type': 'proof_posted',
          'circleName': circleName,
          'authorName': authorName,
        }),
      );
    } catch (e) {
      debugPrint('Error sending proof posted notification: $e');
    }
  }

  // Send comment/reaction notification
  Future<void> sendInteractionNotification({
    required String actorName,
    required String circleName,
    required String activityTitle,
    required String interactionType, // 'comment', 'fire', 'respect', 'push'
  }) async {
    try {
      String emoji;
      switch (interactionType) {
        case 'fire':
          emoji = '🔥';
          break;
        case 'respect':
          emoji = '🤝';
          break;
        case 'push':
          emoji = '⚡';
          break;
        case 'comment':
        default:
          emoji = '💬';
          break;
      }

      await _showNotification(
        id: 104,
        title: '$emoji $actorName reacted to your post',
        body: '$activityTitle in "$circleName"',
        channelId: 'general_notifications',
        payload: jsonEncode({
          'type': 'interaction',
          'circleName': circleName,
          'actorName': actorName,
          'interactionType': interactionType,
        }),
      );
    } catch (e) {
      debugPrint('Error sending interaction notification: $e');
    }
  }

  // Send weekly summary notification
  Future<void> sendWeeklySummaryNotification({
    required int totalPosts,
    required int activeDays,
    required int longestStreak,
    required int circlesCount,
  }) async {
    try {
      await _showNotification(
        id: 105,
        title: '📊 Your Weekly Summary',
        body:
            '$totalPosts posts, $activeDays active days, $longestStreak day best streak across $circlesCount circles',
        channelId: 'general_notifications',
        payload: jsonEncode({
          'type': 'weekly_summary',
        }),
      );
    } catch (e) {
      debugPrint('Error sending weekly summary: $e');
    }
  }

  // Send FCM notification (from push service)
  Future<void> sendFcmNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      final payload = data != null ? jsonEncode(data) : null;
      await _showNotification(
        id: id,
        title: title,
        body: body,
        channelId: 'general_notifications',
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error sending FCM notification: $e');
    }
  }

  // Helper method to show notifications
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    try {
      // Request permission if not granted (only for Android 13+)
      if (Platform.isAndroid) {
        try {
          final status = await Permission.notification.status;
          if (status.isDenied) {
            await Permission.notification.request();
          }
        } catch (e) {
          // Permission might not be available on older Android versions
        }
      }

      // Android notification details
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            channelId,
            channelId == 'streak_reminders'
                ? 'Streak Reminders'
                : channelId == 'deadline_reminders'
                ? 'Deadline Reminders'
                : 'General Notifications',
            channelDescription: channelId == 'streak_reminders'
                ? 'Daily reminders to maintain your streak'
                : channelId == 'deadline_reminders'
                ? 'Reminders for circle daily deadlines'
                : 'General app notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            icon: 'ic_notification',
            styleInformation: BigTextStyleInformation(body),
          );

      // iOS notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Notification details for both platforms
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Show notification
      await _notifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Check Android schedule exact alarm permission
  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      debugPrint('Schedule exact alarm permission: $status.');
      if (status.isDenied) {
        debugPrint('Requesting schedule exact alarm permission...');
        final res = await Permission.scheduleExactAlarm.request();
        debugPrint(
          'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
        );
      }
    }
  }

  /// Schedule daily deadline reminder
  Future<void> scheduleDailyDeadlineReminder({
    required String circleName,
    required int circleId,
    required TimeOfDay deadlineTime,
    required int reminderHoursBefore,
  }) async {
    try {
      await checkAndroidScheduleExactAlarmPermission();

      final now = DateTime.now();
      final deadlineDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        deadlineTime.hour,
        deadlineTime.minute,
      );

      // If deadline has passed today, schedule for tomorrow
      if (deadlineDateTime.isBefore(now)) {
        // We'll just show a notification now for today
        await sendDeadlineReminder(
          circleName: circleName,
          deadlineTime:
              '${deadlineTime.hour.toString().padLeft(2, '0')}:${deadlineTime.minute.toString().padLeft(2, '0')}',
          hoursUntilDeadline: 0,
        );
        return;
      }

      // Schedule reminder X hours before deadline
      final reminderTime = deadlineDateTime.subtract(
        Duration(hours: reminderHoursBefore),
      );

      // If reminder time has passed, schedule for tomorrow
      if (reminderTime.isBefore(now)) {
        // Schedule for tomorrow
        final tomorrowReminder = reminderTime.add(const Duration(days: 1));
        await _scheduleNotificationAt(
          id: 200 + circleId,
          title: '⏰ Deadline Reminder',
          body:
              'Post your proof for "$circleName" by ${deadlineTime.hour.toString().padLeft(2, '0')}:${deadlineTime.minute.toString().padLeft(2, '0')}',
          scheduledDate: tomorrowReminder,
          channelId: 'deadline_reminders',
          payload: jsonEncode({
            'type': 'deadline_reminder',
            'circleName': circleName,
            'circleId': circleId,
          }),
        );
      } else {
        await _scheduleNotificationAt(
          id: 200 + circleId,
          title: '⏰ Deadline Reminder',
          body:
              'Post your proof for "$circleName" by ${deadlineTime.hour.toString().padLeft(2, '0')}:${deadlineTime.minute.toString().padLeft(2, '0')}',
          scheduledDate: reminderTime,
          channelId: 'deadline_reminders',
          payload: jsonEncode({
            'type': 'deadline_reminder',
            'circleName': circleName,
            'circleId': circleId,
          }),
        );
      }

      // Also schedule a 1-hour before reminder
      final oneHourBefore = deadlineDateTime.subtract(const Duration(hours: 1));
      if (oneHourBefore.isAfter(now)) {
        await _scheduleNotificationAt(
          id: 300 + circleId,
          title: '⚠️ Last Hour!',
          body: 'Only 1 hour left for "$circleName" deadline!',
          scheduledDate: oneHourBefore,
          channelId: 'deadline_reminders',
          payload: jsonEncode({
            'type': 'deadline_reminder',
            'circleName': circleName,
            'circleId': circleId,
            'urgent': true,
          }),
        );
      }
    } catch (e) {
      debugPrint('Error scheduling deadline reminder: $e');
    }
  }

  Future<void> _scheduleNotificationAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelId,
    required String payload,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            channelId,
            channelId == 'streak_reminders'
                ? 'Streak Reminders'
                : channelId == 'deadline_reminders'
                ? 'Deadline Reminders'
                : 'General Notifications',
            channelDescription: channelId == 'streak_reminders'
                ? 'Daily reminders to maintain your streak'
                : channelId == 'deadline_reminders'
                ? 'Reminders for circle daily deadlines'
                : 'General app notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            icon: 'ic_notification',
            styleInformation: BigTextStyleInformation(body),
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel scheduled notifications for a circle
  Future<void> cancelCircleNotifications(int circleId) async {
    await _notifications.cancel(200 + circleId);
    await _notifications.cancel(300 + circleId);
  }
}
