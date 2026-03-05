import 'package:flutter/material.dart';
import 'pelanggan_detail.dart';
import 'rekanan_detail.dart';

class PelangganIndexPage extends StatefulWidget {
  const PelangganIndexPage({super.key});

  @override
  State<PelangganIndexPage> createState() => _PelangganIndexPageState();
}

class _PelangganIndexPageState extends State<PelangganIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showFormPelanggan() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar bottom sheet bisa mengikuti tinggi konten
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Geser ke atas jika keyboard muncul
            left: 20,
            right: 20,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Buat Pelanggan Individu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildFieldLabel("Nama Lengkap"),
                _buildTextField(hint: "Chaerul Alam Budijono"),
                
                _buildFieldLabel("No. WhatsApp"),
                _buildTextField(hint: "08561310664", keyboardType: TextInputType.phone),
                
                _buildFieldLabel("Email"),
                _buildTextField(hint: "mendinglaundry@gmail.com", keyboardType: TextInputType.emailAddress),
                
                _buildFieldLabel("Alamat Lengkap"),
                _buildTextField(
                  hint: "Jalan Merdeka No. 15, RT 05/RW 02, Kelurahan Gambir, Kecamatan Gambir, Jakarta Pusat, 10110.",
                  maxLines: 3,
                ),
                
                _buildFieldLabel("Link Titik Lokasi"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "masukkan link titik lokasi Gmaps Pelanggan",
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tombol Batalkan
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE3F2FD)),
                      backgroundColor: const Color(0xFFEBF2FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Batalkan', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- FUNGSI BARU: FORM REKANAN ---
  void _showFormRekanan() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Buat Pelanggan Rekanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildFieldLabel("Nama Outlet Rekanan"),
                _buildTextField(hint: "Ex : ML Dropship Kedung Waringin"),
                
                _buildFieldLabel("Nama (Sesuai KTP)"),
                _buildTextField(hint: "Nama Pic"),
                
                _buildFieldLabel("No. WhatsApp"),
                _buildTextField(hint: "081234567890", keyboardType: TextInputType.phone),
                
                _buildFieldLabel("Email"),
                _buildTextField(hint: "admin@perusahaan.com", keyboardType: TextInputType.emailAddress),
                
                _buildFieldLabel("Alamat Lengkap"),
                _buildTextField(
                  hint: "Masukkan alamat lengkap kantor rekanan...",
                  maxLines: 3,
                ),
                _buildFieldLabel("Link Titik Lokasi"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "masukkan link titik lokasi Gmaps Pelanggan",
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan Rekanan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Tombol Batalkan
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE3F2FD)),
                      backgroundColor: const Color(0xFFEBF2FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Batalkan', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget untuk label input
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  // Helper widget untuk TextField
  Widget _buildTextField({required String hint, int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
        ),
      ),
    );
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
          'Pelanggan',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Individu'),
            Tab(text: 'Rekanan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPelangganList(isIndividu: true), // Tab Individu
          _buildPelangganList(isIndividu: false), // Tab Rekanan
        ],
      ),
      // Tombol di bagian bawah
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          // Cek index tab: 0 untuk Individu, 1 untuk Rekanan
          bool isIndividuTab = _tabController.index == 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isIndividuTab) {
                        _showFormPelanggan();
                      } else {
                        _showFormRekanan();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      isIndividuTab ? 'Buat Pelanggan Individu' : 'Buat Pelanggan Rekanan',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Color(0xFF1E3A8A)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(bool isIndividu) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: isIndividu ? 'Cari Pelanggan Individu' : 'Cari Rekanan',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            children: const [
              Icon(Icons.tune, color: Colors.grey), // Menggunakan tune agar lebih mirip filter desain
              Text('Filter', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPelangganList({required bool isIndividu}) {
    return Column(
      children: [
        // Search Bar tetap sama
        _buildSearchBar(isIndividu),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: isIndividu 
            ? [
                // Data Individu (yang sudah dibuat sebelumnya)
                _buildPelangganCard(
                  name: 'Muhammad Fikri Firdaus:',
                  transactions: '42 Transaksi',
                  phone: '08109927276',
                  amount: 'Rp435.000',
                  isMembership: true,
                  onTap: () { // Masukkan di sini
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PelangganDetailPage()),
                    );
                  },
                ),
                
                const SizedBox(height: 12),
                _buildPelangganCard(
                  name: 'Budi Santoso:',
                  transactions: '10 Transaksi',
                  phone: '08123456789',
                  amount: 'Rp120.000',
                ),
              ]
            : [
                // --- DATA DUMMY REKANAN ---
                _buildPelangganCard(
                  name: 'PT. Maju Jaya Sejahtera',
                  transactions: '150 Transaksi',
                  phone: '021-5556789',
                  amount: 'Rp12.500.000',
                  isMembership: true,
                  onTap: () {
                    // MENGARAH KE HALAMAN REKANAN DETAIL
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RekananDetailPage()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildPelangganCard(
                  name: 'CV. Berkah Laundry Utama',
                  transactions: '85 Transaksi',
                  phone: '081122334455',
                  amount: 'Rp4.200.000',
                  isMembership: false,
                ),
              ],
          ),
        ),
      ],
    );
  }

  Widget _buildPelangganCard({
    required String name,
    required String transactions,
    required String phone,
    required String amount,
    bool isMembership = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Shadow diperbaiki agar lebih "cool" dan terlihat menonjol
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell( // 2. Bungkus dengan InkWell untuk efek klik
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (isMembership)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8BC34A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Membership',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(transactions, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        Text(phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.more_horiz, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        amount,
                        style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}