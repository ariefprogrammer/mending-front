import 'package:flutter/material.dart';

class LaporanPolaTransaksiPage extends StatelessWidget {
  const LaporanPolaTransaksiPage({super.key});

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
          'Laporan Pola Transaksi', //
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w400, 
            fontSize: 18
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data yang ditampilkan", //
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Daftar Pola Transaksi
            _buildBulletPoint("Pola transaksi berdasarkan ", "waktu", " ter ramai"),
            _buildBulletPoint("Pola transaksi berdasarkan ", "hari", " ter ramai"),
            _buildBulletPoint("Pola transaksi berdasarkan ", "minggu", " ter ramai"),
            _buildBulletPoint("Pola transaksi berdasarkan ", "bulan", " ter ramai"),
            _buildBulletPoint("Pola transaksi berdasarkan ", "quartal", " ter ramai"),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String prefix, String highlight, String suffix) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(" • ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                children: [
                  TextSpan(text: prefix),
                  TextSpan(
                    text: highlight, //
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: suffix),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}