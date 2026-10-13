import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_flutter/services/notification_service.dart';
import 'package:circle_flutter/services/push_notification_service.dart';
import 'client.dart';
import 'theme.dart';
import 'main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

  // Initialize notification services
  await NotificationService().initialize();
  await PushNotificationService().initialize();

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
      home: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),

        child: const MainShell(), // ← was HomeScreen
      ),
    );
  }
}
