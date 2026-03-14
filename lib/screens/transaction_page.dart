// lib/screens/transaction_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'transaksi/transaction_detail_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaksi', //
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian Search & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Transaksi',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSortButton(),
                    const SizedBox(width: 8),
                    _buildFilterDropdown(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Daftar Transaksi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTransactionCard(
                  context: context,
                  id: "TRL/52134/2507/9999",
                  name: "Muh Fikri Firdaus",
                  phone: "0812 3456 7889",
                  entryDate: "03 Jan 2025, 16:45",
                  finishDate: "04 Jan 2025, 16:45",
                  total: "Rp 150.000",
                  paymentStatus: "Lunas",
                  processStatus: "Diterima",
                  paymentColor: Colors.green,
                  processColor: Colors.cyan,
                ),
                _buildTransactionCard(
                  context: context,
                  id: "TRL/52134/2507/9999",
                  name: "Muh Fikri Firdaus",
                  phone: "0812 3456 7889",
                  entryDate: "03 Jan 2025, 16:45",
                  finishDate: "04 Jan 2025, 16:45",
                  total: "Rp 150.000",
                  paymentStatus: "Belum bayar",
                  processStatus: "Dikeringkan",
                  paymentColor: Colors.red,
                  processColor: Colors.orange,
                ),
                _buildTransactionCard(
                  context: context,
                  id: "TRL/52134/2507/9999",
                  name: "Muh Fikri Firdaus",
                  phone: "0812 3456 7889",
                  entryDate: "03 Jan 2025, 16:45",
                  finishDate: "04 Jan 2025, 16:45",
                  total: "Rp 150.000",
                  paymentStatus: "Bayar sebagian",
                  processStatus: "Disetrika",
                  paymentColor: Colors.purple,
                  processColor: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1E3A8A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  // Widget Button Urutkan
  Widget _buildSortButton() {
    return Column(
      children: const [
        Icon(Icons.swap_vert, size: 20),
        Text("Urutkan", style: TextStyle(fontSize: 10)),
      ],
    );
  }

  // Widget Dropdown Filter
  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Text("Status Pesanan", style: TextStyle(fontSize: 12)),
          Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  // Widget Kartu Transaksi
  Widget _buildTransactionCard({
    required String id,
    required String name,
    required String phone,
    required String entryDate,
    required String finishDate,
    required String total,
    required String paymentStatus,
    required String processStatus,
    required Color paymentColor,
    required Color processColor,
    required BuildContext context,
  }) {
    return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransactionDetailPage()),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 13)),
              Row(
                children: [
                  _buildStatusChip(paymentStatus, paymentColor),
                  const SizedBox(width: 4),
                  _buildStatusChip(processStatus, processColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              Text(entryDate, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(phone, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              Text(finishDate, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}