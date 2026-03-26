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
import '../data/models/outlet_model.dart';
import '../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'outlet/outlet_buat_outlet.dart';


class DashboardPage extends StatefulWidget { 
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List<Outlet> _outlets = [];
  bool _isLoadingOutlets = false;
  String _activeOutletName = "Pilih Outlet"; 
  int? _activeOutletId;

  @override
  void initState() {
    super.initState();
    _fetchOutlets(); 
    _loadSavedOutlet();
  }

  void _keHalamanBuatOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuatOutletPage()),
    );

    if (result == true) {
      _fetchOutlets(); // List outlet akan di-refresh otomatis
      _loadSavedOutlet(); // Nama outlet di header juga di-refresh
    }
  }

  void _bukaDetailOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OutletIndexPage()),
    );

    if (result == true) {
      _fetchOutlets(); 
      _loadSavedOutlet(); 
    }
  }

  Future<void> _loadSavedOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _activeOutletName = prefs.getString('active_outlet_name') ?? "Pilih Outlet";
      _activeOutletId = prefs.getInt('active_outlet_id');
    });
  }

  Future<void> _fetchOutlets() async {
    setState(() => _isLoadingOutlets = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.outlets),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan Token di sini
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Response Data: ${response.body}");
        final List<dynamic> data = jsonDecode(response.body)['data']; 
        setState(() {
          _outlets = data.map((json) => Outlet.fromJson(json)).toList();
        });
      } else {
        print("Gagal mengambil outlet: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetch outlets: $e");
    } finally {
      setState(() => _isLoadingOutlets = false);
    }
  }

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
                          InkWell(
                            onTap: () => _showOutletPicker(context), // Panggil bottom sheet daftar outlet
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Outlet Anda',
                                      style: TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _activeOutletName,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                                        ),
                                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                const Icon(Icons.qr_code_scanner, color: Colors.white),
                                const SizedBox(width: 10),
                                const Icon(Icons.notifications_none, color: Colors.white),
                              ],
                            ),
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
                      onTap: () => _bukaDetailOutlet(),
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

  void _showOutletPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih Outlet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              
              // Loading Indicator jika data masih diambil
              if (_isLoadingOutlets)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )
              else if (_outlets.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Belum ada outlet tersedia"),
                )
              else
                // Tampilkan List Outlet dari API
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _outlets.length,
                    itemBuilder: (context, index) {
                      final outlet = _outlets[index];
                      return ListTile(
                        leading: const Icon(Icons.storefront, color: Color(0xFF1E3A8A)),
                        title: Text(outlet.name),
                        subtitle: Text("Kode: ${outlet.outletCode}"),
                        onTap: () async {
                          // 1. Simpan ke SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('active_outlet_id', outlet.id);
                          await prefs.setString('active_outlet_name', outlet.name);
                          await prefs.setString('active_outlet_code', outlet.outletCode);

                          // 2. Update State agar UI langsung berubah (Header Dashboard)
                          setState(() {
                            _activeOutletName = outlet.name; // Pastikan variabel ini yang dipakai di Header
                          });

                          // 3. Tutup Bottom Sheet
                          if (!mounted) return;
                          Navigator.pop(context);

                          // 4. (Opsional) Panggil ulang data transaksi/ringkasan khusus outlet ini
                          // _fetchDashboardData(outlet.id); 
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Outlet aktif: ${outlet.name}')),
                          );
                        },
                      );
                    },
                  ),
                ),
            
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _keHalamanBuatOutlet(); 
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Outlet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}