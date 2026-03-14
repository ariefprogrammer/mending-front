import 'package:flutter/material.dart';

class PemetaanBukuKasPage extends StatefulWidget {
  const PemetaanBukuKasPage({super.key});

  @override
  State<PemetaanBukuKasPage> createState() => _PemetaanBukuKasPageState();
}

class _PemetaanBukuKasPageState extends State<PemetaanBukuKasPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State untuk menyimpan pilihan dropdown setiap metode
  final Map<String, String> _mappedData = {
    "Tunai": "Pendapatan",
    "Transfer": "Pendapatan",
    "QRIS": "Pendapatan",
    "Gopay": "Pendapatan",
    "OVO": "Rekening",
    "Dana": "Rekening",
    "ShopeePay": "Rekening",
    "LinkAja": "Rekening",
  };

  final List<String> _bukuKasOptions = ["Pendapatan", "Rekening", "Petty Cash"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Tab Pendapatan & Pengeluaran
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
          'Pemetaan Buku Kas', //
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A), // Biru Brand
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          tabs: const [
            Tab(text: "Pendapatan"),
            Tab(text: "Pengeluaran"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMappingPendapatanList(), 
          _buildMappingPengeluaranList(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Logika simpan pemetaan
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), //
          ),
        ),
      ),
    );
  }

  Widget _buildMappingPendapatanList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _mappedData.keys.map((method) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Metode (contoh: Tunai, QRIS)
              Text(
                method,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              // Dropdown Pemetaan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _mappedData[method],
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _bukuKasOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _mappedData[method] = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMappingPengeluaranList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _mappedData.keys.map((method) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Metode (contoh: Tunai, QRIS)
              Text(
                method,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              // Dropdown Pemetaan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _mappedData[method],
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _bukuKasOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _mappedData[method] = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}