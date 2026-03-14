import 'package:flutter/material.dart';
import '../widgets/dashed_line.dart';

class NotaPreviewPage extends StatelessWidget {
  const NotaPreviewPage({super.key});

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
          'Contoh Nota', //
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          children: [
            // Logo & Header
            const Icon(Icons.local_laundry_service, size: 60, color: Colors.black),
            const SizedBox(height: 8),
            const Text("MENDING LAUNDRY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const Text("MENDING LAUNDRY AKHIRAT", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text(
              "Jl. Raya Surga dan Neraka, RT/RW 001/001,\nAkhirat, Liang Kubur, Indonesia\n+62 857 1098 0147",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            
            const SizedBox(height: 16),
            const DashedLine(color: Colors.black54), //
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            
            // Nama Pelanggan
            const Text("Joko Tingkir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),

            // Detail Transaksi
            _buildRowDetail("ID Transaksi", "TRL/52134/2507/9999"),
            _buildRowDetail("Waktu Transaksi Masuk", "01 Januari 2025 | 15:56"),
            _buildRowDetail("Waktu Transaksi Selesai", "02 Januari 2025 | 15:56"),
            _buildRowDetail("Kasir", "Supervisor - Ahmad Nurfaizi"),
            
            const SizedBox(height: 8),
            const DashedLine(color: Colors.black54), //
            const SizedBox(height: 8),
            
            // Layanan
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("LAYANAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 8),
            _buildRowDetail("Cuci Kering Lipat", ""),
            _buildRowDetail("3 KG X Rp 4.000", "Rp 12.000"),
            _buildRowDetail("Item : 12 PCS", ""),

            const SizedBox(height: 8),
            const DashedLine(color: Colors.black54), //
            const SizedBox(height: 8),

            // Rincian Biaya
            _buildRowDetail("Subtotal", "Rp 12.000"),
            _buildRowDetail("Diskon", "Rp 2.000"),
            _buildRowDetail("PPN (%)", "0%"),
            _buildRowDetail("PPN (Rp)", "Rp 0"),
            _buildRowDetail("Pembulatan", "Rp 0"),
            
            const SizedBox(height: 8),
            const DashedLine(color: Colors.black54), //
            const SizedBox(height: 8),
            
            // Total
            _buildRowDetail("Total", "Rp 10.000", isBold: true),
            const SizedBox(height: 8),
            const DashedLine(color: Colors.black54), //
            const SizedBox(height: 8),

            // Status Pembayaran
            _buildRowDetail("LUNAS - TUNAI", "01 Januari 2025 | 16:00", isBold: true),
            _buildRowDetail("Jumlah Dibayarkan", "Rp 50.000"),
            _buildRowDetail("Kembalian", "Rp 40.000"),

            const SizedBox(height: 32),
            // Placeholder QR Code
            Container(
              width: 120,
              height: 120,
              color: Colors.grey.shade200,
              child: const Icon(Icons.qr_code_2, size: 100),
            ),
            const SizedBox(height: 16),
            const Text("Scan Untuk Pengambilan", style: TextStyle(fontSize: 12)),
            const Text("(FOOTER SETELAH BARCODE)", style: TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRowDetail(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label, 
              style: TextStyle(
                fontSize: 11, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal
              )
            )
          ),
          Text(
            value, 
            style: TextStyle(
              fontSize: 11, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }
}