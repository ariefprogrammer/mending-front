import 'package:flutter/material.dart';
import 'karyawan_create.dart';
import 'buat_slip_gaji.dart';

class KaryawanIndexPage extends StatefulWidget {
  const KaryawanIndexPage({super.key});

  @override
  State<KaryawanIndexPage> createState() => _KaryawanIndexPageState();
}

class _KaryawanIndexPageState extends State<KaryawanIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _karyawanData = [
    {
      "id": "UK - 37120013",
      "jabatan": "Supervisor",
      "nama": "Ahmad Nurfaizi",
      "upah": "Rp1.000.000",
      "hari_kerja": 0,
      "izin": 0,
    },
    {
      "id": "UK - 27120201",
      "jabatan": "Setrika",
      "nama": "Ade Sumiati",
      "upah": "Rp1.000.000",
      "hari_kerja": 0,
      "izin": 0,
    },
  ];

  final List<String> _jabatanList = [
    "Supervisor",
    "Kasir",
    "Setrika",
  ];

  final List<Map<String, dynamic>> _slipGajiList = [
    {
      "jabatan": "Supervisor",
      "nama": "Ahmad Nurfaizi",
      "periode": "01 Jan - 31 Jan 2025",
      "nominal": "-Rp 12.000.000",
      "totalKaryawan": "4 Karyawan",
    },
    {
      "jabatan": "Supervisor",
      "nama": "Ahmad Nur",
      "periode": "01 Des - 31 Des 2025",
      "nominal": "-Rp 12.000.000",
      "totalKaryawan": "4 Karyawan",
    },
    {
      "jabatan": "Supervisor",
      "nama": "Tjipta Perkasa Rahardja",
      "periode": "01 Nov - 31 Nov 2025",
      "nominal": "-Rp 9.000.000",
      "totalKaryawan": "4 Karyawan",
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 Tab sesuai desain
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
          'Karyawan',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          indicatorWeight: 3,
          isScrollable: false,
          tabs: const [
            Tab(text: 'Karyawan'),
            Tab(text: 'Jabatan/Posisi'),
            Tab(text: 'Slip Gaji'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKaryawanTab(),
          _buildJabatanTab(),
          _buildSlipGajiTab(),
        ],
      ),
      
      // Bottom Navigation Bar yang Dinamis
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          // Menentukan teks dan aksi berdasarkan index tab yang aktif
          String buttonText;
          VoidCallback onPressed;

          if (_tabController.index == 0) {
            buttonText = 'Buat Karyawan Baru';
            onPressed = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KaryawanCreatePage()),
              );
            };
          } else if (_tabController.index == 1) {
            buttonText = 'Buat Jabatan/Posisi';
            onPressed = () {
              // Logika untuk tambah jabatan baru
            };
          } else {
            buttonText = 'Buat Slip Gaji';
            onPressed = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuatSlipGajiPage()),
              );
            };
          }

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), 
                  blurRadius: 10, 
                  offset: const Offset(0, -5)
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKaryawanTab() {
    return Column(
      children: [
        // Search & Sort Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Karyawan',
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Column(
                children: [
                  Icon(Icons.swap_vert, color: Colors.grey),
                  Text('Urutkan', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ],
          ),
        ),

        // List Karyawan
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _karyawanData.length,
            itemBuilder: (context, index) {
              final item = _karyawanData[index];
              return _buildKaryawanCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKaryawanCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['id'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      "${data['jabatan']} - ${data['nama']}",
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFF424242)),
                    ),
                  ],
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Estimasi Total Upah", data['upah']),
                _buildVerticalDivider(),
                _buildStatItem("Hari Kerja", data['hari_kerja'].toString()),
                _buildVerticalDivider(),
                _buildStatItem("Izin/Libur", data['izin'].toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  Widget _buildJabatanTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jabatanList.length,
            itemBuilder: (context, index) {
              return _buildJabatanCard(_jabatanList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJabatanCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF424242),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _showDeleteConfirmation(title);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                onPressed: () {
                  // Logika edit jabatan
                },
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A8A)),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus Jabatan "$title"?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF1E3A8A)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Tidak', style: TextStyle(color: Color(0xFF1E3A8A))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Eksekusi hapus
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Ya', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSlipGajiTab() {
    return Column(
      children: [
        // Search Bar & Sort sesuai desain index
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
                      hintText: 'Cari Slip Gaji',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: const [
                  Icon(Icons.swap_vert, color: Colors.grey),
                  Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _slipGajiList.length,
            itemBuilder: (context, index) {
              return _buildSlipGajiCard(_slipGajiList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlipGajiCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['jabatan'], style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 14)),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['nama'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
              Text(data['nominal'], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['periode'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(data['totalKaryawan'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }
}