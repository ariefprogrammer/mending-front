// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard.dart';
import 'screens/auth_page.dart';

void main() async {
  // 1. Wajib ada agar plugin (SharedPreferences) bisa berjalan
  WidgetsFlutterBinding.ensureInitialized();
  
  bool loggedInStatus = false;

  try {
    // 2. Ambil instance SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // 3. Gunakan operator ?? false untuk memastikan TIDAK PERNAH null
    loggedInStatus = prefs.getBool('is_logged_in') ?? false;
  } catch (e) {
    // Jika terjadi error saat baca storage, default ke false (halaman login)
    loggedInStatus = false;
  }

  runApp(MyApp(isLoggedIn: loggedInStatus));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Pastikan tipenya bool (bukan bool?)
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WashPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      // Jika isLoggedIn tetap null karena suatu alasan, operator ?? di sini adalah pertahanan terakhir
      home: isLoggedIn ? const DashboardPage() : const AuthPage(),
    );
  }
}