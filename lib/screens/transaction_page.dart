// lib/screens/transaction_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        backgroundColor: const Color(0xFF1E2B3A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Transaksi'),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}