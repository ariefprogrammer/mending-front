// lib/screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Tambahkan dependency ini di pubspec.yaml
import '../models/menu_item.dart';
import '../widgets/bottom_nav_bar.dart';
import 'auth_page.dart';
import 'pelanggan/pelanggan_index.dart';
import 'layanan/layanan_index.dart';
import 'karyawan/karyawan_index.dart';
import 'assets/asset_index.dart';
import 'bahan/bahan_index.dart';
import 'pemasukan/pemasukan_index.dart';
import 'pengeluaran/pengeluaran_index.dart';
import 'bukukas/bukukas_index.dart';
import 'pesanmasal/pesanmasal_index.dart';
import 'formulir/formulir_index.dart';
import 'outlet/outlet_index.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Stack(
              children: [
                // Background Biru (Tinggi disesuaikan agar menutupi area chart)
                Container(
                  height: 430,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E3A8A), // Biru Navy sesuai desain
                  ),
                ),
                
                // Konten di atas Background Biru
                Column(
                  children: [
                    const SizedBox(height: 50),
                    // Baris Outlet dan Icon (Header)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. Ikon Grid tetap di pojok kiri
                          const Icon(Icons.grid_view_rounded, color: Colors.white),

                          // 2. Grup Kanan: Teks Outlet + Barcode + Notifikasi
                          Row(
                            children: [
                              // Kolom Teks (Outlet Anda & Bojong Gede)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end, // Membuat teks rata kanan (align-right)
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Outlet Anda', 
                                    style: TextStyle(color: Colors.white70, fontSize: 14)
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'Bojong Gede', 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)
                                      ),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                              
                              const SizedBox(width: 15), // Jarak kecil agar teks tidak benar-benar menempel ke ikon
        
                              
                              // Barcode Scanner
                              const Icon(Icons.qr_code_scanner, color: Colors.white),
                              
                              const SizedBox(width: 10), // Jarak antar ikon
                              
                              // Notifikasi
                              const Icon(Icons.notifications_none, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Saldo atau omset card kecil
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Ikon dompet tetap di kiri sendirian
                          const Icon(Icons.account_balance_wallet, color: Color(0xFF1E3A8A), size: 20),
                          
                          // Kita bungkus Teks dan Ikon Grid ke dalam Row lagi
                          Row(
                            children: [
                              const Text(
                                'Rp 1.500.000',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 79, 87, 110), 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(width: 4), // Beri jarak sedikit (misal 4px) agar tidak benar-benar dempet
                              const Icon(Icons.qr_code_scanner, color: Color(0xFF1E3A8A), size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  
                    // --- CARD CHART PUTIH ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), // Corner radius 10px
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label Omset di dalam Card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Omset hari ini', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text('Rp50.000.000', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E3A8A))),
                            ],
                          ),
                          const SizedBox(height: 10), // Jarak atas garis
                          Divider(
                            color: Color(0xFF1E3A8A), // Warna abu-abu halus
                            thickness: 1.5, // Ketebalan garis
                          ),
                          const SizedBox(height: 5),
                          // Grafik Batang
                          SizedBox(
                            height: 125,
                            child:Padding(
                              // Tambahkan padding horizontal di sini
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar('KG', 'Rp 1.000.000/100 Kg', 0.9),
                                  _buildBar('PCS', 'Rp 400.000/8 Pcs', 0.6),
                                  _buildBar('SET', 'Rp 100.000/2 Set', 0.4),
                                  _buildBar('CM', 'Rp 0/0 CM', 0.7),
                                  _buildBar('M', 'Rp 0/0 M', 0.8),
                                  _buildBar('M2', 'Rp 0/0 M²', 0.5),
                                  _buildBar('M3', 'Rp 0/0 M³', 0.6),
                                ],
                              ),  
                            ),
                          ),
                          // const SizedBox(height: 10),
                          // const Center(child: Text('● ○ ○ ○ ○', style: TextStyle(color: Colors.blue, fontSize: 8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --- MENU CARD ---
            Transform.translate(
              offset: const Offset(0, -30), // Angka -30 artinya menggeser ke ATAS sebanyak 30px
              child:Container( 
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Jarak di dalam card
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  alignment: WrapAlignment.start, // Mengatur rata kiri untuk item menu
                  runSpacing: 20, // Jarak antar baris (atas-bawah)
                  children: [
                    _buildMenuItem(
                      Icons.people_outline, 
                      'Pelanggan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PelangganIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.room_service_outlined, 
                      'Layanan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LayananIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.group_outlined, 
                      'Karyawan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KaryawanIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.timer_outlined,
                      'Kehadiran'
                      
                    ),
                    _buildMenuItem(
                      Icons.inventory_2_outlined, 
                      'Aset',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AssetIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.opacity, 
                      'Bahan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BahanIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.account_balance_wallet_outlined, 
                      'Pemasukan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PemasukanIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.payments_outlined, 
                      'Pengeluaran',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PengeluaranIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.menu_book_outlined, 
                      'Buku Kas',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BukuKasIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.forward_to_inbox_outlined, 
                      'Pesan Masal',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PesanMasalPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.assignment_outlined, 
                      'Formulir',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FormulirIndexPage()),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.storefront_outlined, 
                      'Outlet',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OutletIndexPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0), 

      // Jika Anda ingin floating action button (seperti di gambar desain)
      // floatingActionButton: FloatingActionButton(
      //   elevation: 8,
      //   backgroundColor: const Color(0xFF1E3A8A),
      //   onPressed: () {},
      //   shape: const CircleBorder(),
      //   child: const Icon(Icons.add, color: Colors.white, size: 35),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
    );
  }

  // Widget untuk Bar Chart Batang
  Widget _buildBar(String label, String value, double heightFactor) {
    // double maxHeight = 80;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 110 * heightFactor,
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
      ],
    );
  }

  // Widget untuk Menu Item sesuai desain lingkaran
  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // Menjalankan fungsi navigasi yang dikirim dari pemanggil
      behavior: HitTestBehavior.opaque, // Memastikan area kosong di sekitar ikon juga bisa diklik
      child: SizedBox(
        width: 95, 
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1E3A8A), 
                  width: 2.5, // Dipertebal dari 1 menjadi 2.5 sesuai keinginanmu
                ),
              ),
              child: Icon(
                icon, 
                color: const Color(0xFF1E3A8A), 
                size: 30, // Ukuran ikon tetap 30
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11, 
                color: Colors.black87,
                fontWeight: FontWeight.w500, // Sedikit dipertebal agar seimbang dengan border ikon
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}