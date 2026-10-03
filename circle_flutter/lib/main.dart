import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client.dart';
import 'theme.dart';
import 'main_shell.dart';

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

        child: const MainShell(), // ← was HomeScreen
      ),
    );
  }
}
