// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/auth_page.dart'; // Jika ada halaman auth

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WashPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}