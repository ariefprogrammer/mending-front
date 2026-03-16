// lib/screens/services_page.dart
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'laporan/laporan_rangkuman.dart';
import 'laporan/laporan_bukukas_besar.dart';
import 'laporan/laporan_transaksi_layanan.dart';
import 'laporan/laporan_pembayaran.dart';
import 'laporan/laporan_pendapatan.dart';
import 'laporan/laporan_proses_pengerjaan.dart';
import 'laporan/laporan_komisi.dart';
import 'laporan/laporan_transaksi_pemasukan.dart';
import 'laporan/laporan_pola_transaksi.dart';
import 'laporan/laporan_transaksi_deposit.dart';
import 'laporan/laporan_pelanggan.dart';
import 'laporan/laporan_peralatan_produksi.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background abu muda bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporan', //
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w400, 
            fontSize: 18
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.black), 
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black), 
            onPressed: () {}
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildServiceItem(
                context, 
                Icons.book_outlined, 
                'Rangkuman Laporan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanRangkumanPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.timeline, 
                'Pola Transaksi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPolaTransaksiPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.account_balance_wallet_outlined, 
                'Buku Kas Besar',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanBukuKasBesarPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.favorite_border, 
                'Laporan Transaksi Layanan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanTransaksiLayananPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.account_balance_outlined, 
                'Laporan Transaksi Deposit',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanTransaksiDepositPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.business_center_outlined, 
                'Laporan Transaksi Pemasukan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPemasukanPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.print_outlined, 
                'Laporan Pembayaran',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPembayaranPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.shopping_basket_outlined, 
                'Laporan Pendapatan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPendapatanPage()),
                  );
                },
              ),
              _buildServiceItem(context, Icons.local_mall_outlined, 'Laporan Pengeluaran'),
              _buildServiceItem(
                context, 
                Icons.point_of_sale_outlined, 
                'Laporan Proses Pengerjaan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanProsesPengerjaanPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.handshake_outlined, 
                'Laporan Komisi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanKomisiPage()),
                  );
                },
              ),
              _buildServiceItem(
                context, 
                Icons.people_outline, 
                'Laporan Pelanggan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPelangganPage()),
                  );
                },
              ),
              _buildServiceItem(context, Icons.badge_outlined, 'Laporan Karyawan'),
              _buildServiceItem(context, Icons.print_outlined, 'Laporan Penggunaan Bahan (Soon)'),
              _buildServiceItem(
                context, 
                Icons.opacity_outlined, 
                'Laporan Peralatan Produksi', 
                isLast: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaporanPeralatanProduksiPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Gunakan currentIndex: 2 agar menu Laporan di navbar aktif
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, 
    IconData icon, 
    String title, 
    {VoidCallback? onTap, bool isLast = false} 
  ) {
    return Column(
      children: [
        ListTile(
          onTap: onTap, // GANTI DISINI: Panggil parameter onTap, jangan gunakan print() lagi
          leading: Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        if (!isLast)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
      ],
    );
  }
}