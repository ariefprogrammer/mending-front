import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPelangganPage extends StatefulWidget {
  const LaporanPelangganPage({super.key});

  @override
  State<LaporanPelangganPage> createState() => _LaporanPelangganPageState();
}

class _LaporanPelangganPageState extends State<LaporanPelangganPage> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 1),
    end: DateTime(2025, 1, 31),
  );

  // Fungsi Date Range Picker agar filter tanggal berfungsi
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A), // Navy
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporan Pelanggan', //
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter Tanggal
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => _selectDateRange(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateFormat('dd MMMM yyyy').format(_selectedDateRange.start)} s/d ${DateFormat('dd MMMM yyyy').format(_selectedDateRange.end)}",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tabel Statistik Pelanggan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildStatRow("Total Pelanggan", "1453 Pelanggan"),
                    _buildStatRow("Pelanggan Baru", "97 Pelanggan"),
                    _buildStatRow("Antar Jemput", "200 Pelanggan"),
                    _buildStatRow("Pelanggan Bertransaksi", "1000 Pelanggan"),
                    _buildStatRow("Pelanggan Tidak Bertransaksi", "453 Pelanggan"),
                    _buildStatRow("Transaksi Terbanyak", "Barsain\nRp 3.000.000", isTwoLine: true),
                    _buildStatRow("Transaksi Kiloan Terbanyak", "Barsain\n260 Kg", isTwoLine: true),
                    _buildStatRow("Transaksi Satuan Terbanyak", "Nugroho\n44 Pcs", isTwoLine: true),
                    _buildStatRow("Transaksi Set Terbanyak", "Adi\n18 Set", isTwoLine: true),
                    _buildStatRow("Transaksi Meter Terbanyak", "Nur\n6 Meter", isTwoLine: true),
                    _buildStatRow("Transaksi M² Terbanyak", "Budi\n23 M²", isTwoLine: true),
                    _buildStatRow("Transaksi M³ Terbanyak", "Samsudin\n23 M³", isTwoLine: true, isLast: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isTwoLine = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isTwoLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label, //
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value, //
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}