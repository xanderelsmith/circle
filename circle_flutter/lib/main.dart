import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_flutter/services/notification_service.dart';
import 'package:circle_flutter/services/push_notification_service.dart';
import 'package:circle_flutter/core/providers/auth_provider.dart';
import 'client.dart';
import 'theme.dart';
import 'main_shell.dart';
import 'features/activity/presentation/screens/activity_thread_screen.dart';
import 'features/activity/domain/activity.dart';
import 'features/circles/presentation/screens/circles_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

  // Initialize notification services
  await NotificationService().initialize();
  await PushNotificationService().initialize(navigatorKey);

  await initializeClient();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeFirebase() async {
  // Firebase initialization happens in the background
  // The actual initialization is handled by the platform-specific code
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
        '/login': (context) => Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.atmosphericBackground,
              ),
              child: const LoginScreen(),
            ),
        '/signup': (context) => Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.atmosphericBackground,
              ),
              child: const SignUpScreen(),
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
          final activity =
              ModalRoute.of(context)!.settings.arguments as Activity;
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
      home: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),
        child: const MainShell(),
      ),
    );
  }
}
