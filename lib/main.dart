import 'package:flutter/material.dart';
import 'package:ilgijjan/screens/splash_screen_v1.dart';
import 'package:ilgijjan/screens/splash_screen_v2.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '일기장',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const SplashScreenV1(),
    );
  }
}
