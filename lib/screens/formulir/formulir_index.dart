import 'package:flutter/material.dart';

class FormulirIndexPage extends StatefulWidget {
  const FormulirIndexPage({super.key});

  @override
  State<FormulirIndexPage> createState() => _FormulirIndexPageState();
}

class _FormulirIndexPageState extends State<FormulirIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController dengan 2 tab: Pelanggan & Karyawan
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Formulir', //
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
        // TabBar untuk navigasi Pelanggan & Karyawan
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A), // Biru brand
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Pelanggan"),
            Tab(text: "Karyawan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFormulirList(type: "Pelanggan"),
          _buildFormulirList(type: "Karyawan"),
        ],
      ),
    );
  }

  Widget _buildFormulirList({required String type}) {
    return Column(
      children: [
        // Search Bar & Sort Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari', //
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: const [
                  Icon(Icons.swap_vert, color: Colors.black87),
                  Text('Urutkan', style: TextStyle(fontSize: 10, color: Colors.black87)), //
                ],
              ),
            ],
          ),
        ),

        // Tombol Buat Formulir
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A), // Biru brand
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Buat Formulir $type", //
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // Area Daftar Formulir (Placeholder)
        const Expanded(
          child: Center(
            child: Text(
              "Belum ada data formulir",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}