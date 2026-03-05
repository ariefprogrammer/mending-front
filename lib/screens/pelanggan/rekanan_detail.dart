import 'package:flutter/material.dart';

class RekananDetailPage extends StatelessWidget {
  const RekananDetailPage({super.key});

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
        titleSpacing: 0,
        title: const Text(
          'Detail Pelanggan Individu',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {}, 
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black)
          ),
          // const SizedBox(width: 15),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {}, 
            icon: const Icon(Icons.notifications_none, color: Colors.black)
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION RINGKASAN SALDO (3 Card di Atas) ---
            Row(
              children: [
                _buildSummaryCard('Deposit', 'Rp1.000.000', const Color(0xFF1E3A8A)),
                const SizedBox(width: 10),
                _buildSummaryCard('Belum Dibayar', 'Rp0', const Color(0xFF1E3A8A)),
                const SizedBox(width: 10),
                _buildSummaryCard('Sudah Dibayar', 'Rp0', const Color(0xFF1E3A8A)),
              ],
            ),
            const SizedBox(height: 24),

            // --- SECTION KONTAK ---
            const Text('Kontak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoItem('Nama Pelanggan Rekanan', 'PT. Maju Jaya Sejahtera'),
              _buildInfoItem('No. WhatsApp', '08561310664'),
              _buildInfoItem('Alamat Lengkap', 'Jalan Merdeka No. 15, RT 05/RW 02, Kelurahan Gambir, Kecamatan Gambir, Jakarta Pusat, 10110.'),
              _buildInfoItem('Terdaftar Sejak', '05 Juli 2025. 16:45 WIB'),
            ]),
            const SizedBox(height: 24),

            // --- SECTION TRANSAKSI ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transaksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ],
            ),
            _buildInfoCard([
              _buildInfoItem('Total Nominal Transaksi', 'Rp1.500.000'),
              _buildInfoItem('Total Transaksi', '84 Transaksi'),
              _buildInfoItem('Transaksi Pertama', '05 Juli 2025. 16:45 WIB'),
            ]),
            const SizedBox(height: 80), // Jarak tambahan agar tidak tertutup button bawah
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  // Widget untuk kartu ringkasan (Deposit, Belum Dibayar, dll)
  Widget _buildSummaryCard(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: valueColor), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // Widget Container Putih untuk membungkus grup informasi
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Widget untuk item informasi detail (Label & Value)
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }

  // Widget tombol aksi di bagian bawah
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Buat Transaksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Color(0xFF1E3A8A)),
            ),
          )
        ],
      ),
    );
  }
}