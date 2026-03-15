// lib/screens/services_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan'),
        backgroundColor: const Color(0xFF1E2B3A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Layanan'),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}