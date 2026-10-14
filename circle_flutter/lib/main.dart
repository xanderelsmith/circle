import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:circle_flutter/services/notification_service.dart';
import 'package:circle_flutter/services/push_notification_service.dart';
import 'firebase_options.dart';
import 'client.dart';
import 'theme.dart';
import 'main_shell.dart';
import 'features/activity/presentation/screens/activity_thread_screen.dart';
import 'features/activity/domain/activity.dart';
import 'features/circles/presentation/screens/circles_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize client first so it is available to the app and services
  try {
    await initializeClient();
  } catch (e) {
    debugPrint('Failed to initialize client: $e');
  }

  // 2. Start the UI immediately to prevent white screen / launch freezes
  runApp(const ProviderScope(child: MyApp()));

  // 3. Initialize background services (Firebase & notifications) without blocking UI
  _initializeBackgroundServices();
}

Future<void> _initializeBackgroundServices() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('NotificationService initialization failed: $e');
  }

  try {
    await PushNotificationService().initialize(navigatorKey);
  } catch (e) {
    debugPrint('PushNotificationService initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.atmosphericBackground,
          ),
          child: const MainShell(),
        ),
        '/circles': (context) => Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.atmosphericBackground,
          ),
          child: const CirclesScreen(),
        ),
        '/profile': (context) => Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.atmosphericBackground,
          ),
          child: const ProfileScreen(),
        ),
        '/leaderboard': (context) => Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.atmosphericBackground,
          ),
          child: const LeaderboardScreen(),
        ),
        '/activity': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final Activity activity;
          if (args is Activity) {
            activity = args;
          } else if (args is Map) {
            activity = Activity(
              id: args['id']?.toString() ?? '1',
              title:
                  args['activityTitle']?.toString() ??
                  args['title']?.toString() ??
                  args['circleName']?.toString() ??
                  'Activity',
              description:
                  args['description']?.toString() ??
                  args['activityTitle']?.toString() ??
                  'Activity details',
              type: ActivityType.habit,
              duration: DurationOption.thirtyDays,
              proofRequirement: ProofRequirement.any,
              visibility: VisibilityScope.public,
              iconEmoji: args['iconEmoji']?.toString() ?? '🔥',
              memberCount: (args['memberCount'] as num?)?.toInt() ?? 1,
              isJoined: true,
              currentDay: 1,
              totalDays: 30,
              coverImageUrl: args['coverImageUrl']?.toString(),
            );
          } else {
            activity = sampleActivity;
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.atmosphericBackground,
            ),
            child: ActivityThreadScreen(activity: activity),
          );
        },
        '/notifications': (context) => Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.atmosphericBackground,
          ),
          child: const NotificationsScreen(),
        ),
      },
    );
  }
}
