import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client.dart';
import 'theme.dart';
<<<<<<< HEAD
import 'main_layout.dart';
=======
import 'screens/main_shell.dart';
>>>>>>> 632bf07b7e76ea78e5c6a2be24592361317bdd0f

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const ProviderScope(child: MyApp()));
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
<<<<<<< HEAD
        child: const MainLayout(),
=======
        child: const MainShell(), // ← was HomeScreen
>>>>>>> 632bf07b7e76ea78e5c6a2be24592361317bdd0f
      ),
    );
  }
}
