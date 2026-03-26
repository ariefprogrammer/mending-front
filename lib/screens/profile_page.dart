// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_page.dart';

class ProfilePage extends StatefulWidget { // UBAH KE STATEFUL
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile dengan Gradasi Biru
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF4A69BD), Color(0xFF1E3A8A)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Outlet',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.qr_code_scanner, color: Colors.white), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Kartu Informasi Pemilik
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFE5E7EB),
                              child: Icon(Icons.person, size: 45, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tjipta Perkasa Rahardja', //
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Pemilik', //
                                    style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kontak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)), //
                  const SizedBox(height: 12),
                  _buildContactCard(),
                  const SizedBox(height: 24),
                  const Text("Pengaturan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)), //
                  const SizedBox(height: 12),
                  _buildSettingsList(),
                  const SizedBox(height: 24),
                  // Tombol Keluar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Tambahkan konfirmasi sebelum keluar (Best Practice)
                        _showLogoutConfirmation(context);
                      },
                      icon: const Icon(Icons.logout), // Saya ganti ke logout agar lebih sesuai dibanding delete
                      label: const Text("Keluar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Version 1.0.0 • © 2025 Laundry", //
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3), // Menyesuaikan indeks profil
    );
  }

  // Widget untuk Bagian Kontak
  Widget _buildContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildContactItem(Icons.phone_outlined, "Nomor Telepon", "0856 9311 4377"), //
          const Divider(height: 1),
          _buildContactItem(Icons.email_outlined, "Email", "Tjipta01@gmail.com"), //
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E3A8A)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk Daftar Pengaturan
  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSettingItem(Icons.person_outline, "Ubah Data Pemilik"), //
          _buildSettingItem(Icons.verified_user_outlined, "Upgrade ke Pro", isPro: true), //
          _buildSettingItem(Icons.description_outlined, "Syarat dan Ketentuan"), //
          _buildSettingItem(Icons.privacy_tip_outlined, "Kebijakan Privasi"), //
          _buildSettingItem(Icons.help_outline, "Pertanyaan Umum"), //
          _buildSettingItem(Icons.headset_mic_outlined, "Bantuan", isLast: true), //
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {bool isPro = false, bool isLast = false}) {
    return ListTile(
      onTap: () {},
      leading: isPro 
        ? Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(4)),
            child: const Text("Pr", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        : Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      shape: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
    );
  }

  Future<void> _handleLogout() async {
    // 1. Tampilkan loading sebentar (opsional tapi bagus untuk UX)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // 2. Panggil API Logout ke Laravel
      final response = await http.post(
        Uri.parse(ApiConstants.logout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // 3. Apapun hasil dari API (berhasil atau token sudah expired), 
      // kita tetap hapus data lokal agar user bisa keluar.
      await prefs.clear(); // Menghapus semua data (token, name, is_logged_in)

      if (!mounted) return;
      
      // 4. Tutup loading dialog dan arahkan ke halaman Login
      Navigator.pop(context); // Tutup loading
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (route) => false, // Hapus semua riwayat navigasi
      );
      
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal keluar: $e')),
      );
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _handleLogout(); // Jalankan fungsi logout
            },
            child: const Text("Keluar", style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }

}