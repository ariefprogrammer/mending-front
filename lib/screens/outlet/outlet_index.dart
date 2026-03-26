import 'package:flutter/material.dart';
import 'outlet_ubah_outlet.dart';
import 'outlet_pengaturan.dart';
import 'outlet_buku_kas.dart';
import 'outlet_metode_pembayaran.dart';
import 'outlet_pemetaan_bukukas.dart';
import 'outlet_pengaturan_nota.dart';
import 'outlet_pengaturan_notifikasi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutletIndexPage extends StatefulWidget {
  const OutletIndexPage({super.key});

  @override
  State<OutletIndexPage> createState() => _OutletIndexPageState();
}

class _OutletIndexPageState extends State<OutletIndexPage> {
  bool _isLoading = true;
  bool _isDataChanged = false;
  Map<String, dynamic>? _outletData;

  @override
  void initState() {
    super.initState();
    _fetchOutletDetail();
  }

  Future<void> _fetchOutletDetail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      // Ambil ID outlet yang sedang aktif dari SharedPreferences
      final int? activeId = prefs.getInt('active_outlet_id');

      if (activeId == null) {
        throw "Silahkan pilih outlet dulu";
      }

      final response = await http.get(
        Uri.parse(ApiConstants.showOutlet(activeId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _outletData = result['data'];
          _isLoading = false;
        });
      } else {
        throw "Gagal memuat data: ${response.statusCode}";
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kirim status perubahan ke Dashboard saat kembali
            Navigator.pop(context, _isDataChanged); 
          },
        ),
        title: const Text(
          'Outlet', //
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.white)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile Card
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: _buildOutletProfileCard(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section Kontak
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Kontak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 12),
            _buildContactCard(),

            const SizedBox(height: 24),

            // Section Pengaturan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Pengaturan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 12),
            _buildSettingsList(),

            const SizedBox(height: 32),

            // Tombol Hapus Outlet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDeleteConfirmation(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text("Hapus Outlet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48), // Merah
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Version 1.0.0 • © 2025 Laundry", //
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOutletProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _outletData?['name'] ?? "Nama Outlet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _outletData?['address'] ?? "Alamat belum diatur",
                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E), // Hijau Pro
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Pro", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text("Tanggal Berakhir: 01 Jan 2026", style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 67, 67, 67))), //
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 214, 214, 214)),
      ),
      child: Column(
        children: [
          _buildContactTile(Icons.phone_outlined, "Nomor Telepon", _outletData?['phone'] ?? "-"), //
          const Divider(height: 1),
          _buildContactTile(Icons.email_outlined, "Email", _outletData?['user']?['email'] ?? "-"), //
        ],
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    final settings = [
      {'icon': Icons.person_outline, 'label': 'Ubah Data Outlet'}, //
      {'icon': Icons.store_outlined, 'label': 'Pengaturan Outlet'},
      {'icon': Icons.star_border, 'label': 'Pengaturan Buku Kas'},
      {'icon': Icons.point_of_sale_outlined, 'label': 'Pengaturan Metode Pembayaran'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'Pemetaan Buku Kas'},
      {'icon': Icons.print_outlined, 'label': 'Pengaturan Nota/Struk'},
      {'icon': Icons.notifications_none, 'label': 'Pengaturan Notifikasi'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: settings.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = settings[index];
          return ListTile(
            leading: Icon(item['icon'] as IconData, color: const Color(0xFF1E3A8A)),
            title: Text(item['label'] as String, style: const TextStyle(fontSize: 14)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              // Logika navigasi berdasarkan label menu
              if (item['label'] == 'Ubah Data Outlet') {
                // 1. Tambahkan await untuk menunggu halaman ditutup
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UbahOutletPage()),
                );

                // 2. Jika result adalah true, panggil fungsi fetch lagi
                if (result == true) {
                  setState(() {
                    _isDataChanged = true; // Tandai bahwa ada perubahan
                  });
                  _fetchOutletDetail(); 
                }
              } else if (item['label'] == 'Pengaturan Outlet') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PengaturanOutletPage()),
                );
              } else if (item['label'] == 'Pengaturan Buku Kas') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PengaturanBukuKasPage()),
                );
              } else if (item['label'] == 'Pengaturan Metode Pembayaran') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MetodePembayaranPage()),
                );
              }  else if (item['label'] == 'Pemetaan Buku Kas') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PemetaanBukuKasPage()),
                );
              }  else if (item['label'] == 'Pengaturan Nota/Struk') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PengaturanNotaPage()),
                );
              }  else if (item['label'] == 'Pengaturan Notifikasi') { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PengaturanNotifikasiPage()),
                );
              }  else {
                // Placeholder untuk menu lainnya
                print("Membuka ${item['label']}");
              }
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Teks Pertanyaan
                const Text(
                  "Apakah Anda yakin ingin menghapus outlet ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                ),
                const SizedBox(height: 16),
                // Teks Peringatan
                const Text(
                  "Outlet yang telah dihapus tidak bisa dipulihkan kembali",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 24),
                // Baris Tombol
                Row(
                  children: [
                    // Tombol Tidak
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFD1E2FF)),
                          backgroundColor: const Color(0xFFF0F7FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Tidak", style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol Ya
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteOutlet();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Ya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteOutlet() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      if (activeId == null) return;

      final response = await http.delete(
        Uri.parse(ApiConstants.showOutlet(activeId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // 1. KOSONGKAN data di SharedPreferences
        await prefs.remove('active_outlet_id');
        await prefs.remove('active_outlet_name');
        await prefs.remove('active_outlet_code');

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Outlet berhasil dihapus")),
        );

        // 2. KEMBALI ke Dashboard dengan membawa sinyal 'true'
        // Ini akan memicu Dashboard untuk menjalankan _fetchOutlets() secara otomatis
        Navigator.pop(context, true); 
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? "Gagal menghapus outlet";
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}