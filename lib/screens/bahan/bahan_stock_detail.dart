import 'package:flutter/material.dart';

class BahanStockDetailPage extends StatelessWidget {
  final String namaPemeriksa;

  const BahanStockDetailPage({super.key, required this.namaPemeriksa});

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
        title: Text(
          'Stok Opname - $namaPemeriksa', // Menampilkan nama sesuai card yang diklik
          style: const TextStyle(
            color: Color(0xFF1E3A8A), 
            fontSize: 16, 
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Bahan 1
            _buildDetailItem("Nama Bahan 1", "Terisi Otomatis"),
            _buildDetailItem("Satuan", "Terisi Otomatis"),
            _buildDetailItem("Stok Berdasar Sistem", "Terisi Otomatis"),

            // Garis Putus-putus Pemisah
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: DashedLinePainter(),
            ),

            // Item Bahan 2
            _buildDetailItem("Nama Bahan 2", "Terisi Otomatis"),
            _buildDetailItem("Satuan", "Terisi Otomatis"),
            _buildDetailItem("Stok Berdasar Sistem", "Terisi Otomatis"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk membuat garis putus-putus
class DashedLinePainter extends StatelessWidget {
  const DashedLinePainter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashSpace = 5.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}