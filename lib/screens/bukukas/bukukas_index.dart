import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bukukas_detail.dart';

class BukuKasIndexPage extends StatefulWidget {
  const BukuKasIndexPage({super.key});

  @override
  State<BukuKasIndexPage> createState() => _BukuKasIndexPageState();
}

class _BukuKasIndexPageState extends State<BukuKasIndexPage> {
  // State untuk range tanggal
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 1),
    end: DateTime(2025, 1, 31),
  );

  // Fungsi untuk menampilkan Date Range Picker
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
              primary: Color(0xFF1E3A8A), // Biru brand
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Format tanggal untuk tampilan
  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
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
          'Buku Kas',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Range Tanggal
            InkWell(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_formatDate(_selectedDateRange.start)} s/d ${_formatDate(_selectedDateRange.end)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Kartu Saldo
            _buildKasCard(
              title: "Pendapatan",
              saldoAkhir: "Rp 0",
              saldoSebelumnya: "Rp 0",
              pendapatan: "Rp 50.000.000",
              pengeluaran: "Rp 50.000.000",
            ),
            _buildKasCard(
              title: "Petty Cash",
              saldoAkhir: "Rp 2.000.000",
              saldoSebelumnya: "Rp 1.000.000",
              pendapatan: "Rp 1.500.000",
              pengeluaran: "Rp 500.000",
            ),
            _buildKasCard(
              title: "Rekening Bank",
              saldoAkhir: "Rp 243.500.000",
              saldoSebelumnya: "Rp 195.000.000",
              pendapatan: "Rp 50.000.000",
              pengeluaran: "Rp 1.500.000",
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Kartu Kas
  Widget _buildKasCard({
    required String title,
    required String saldoAkhir,
    required String saldoSebelumnya,
    required String pendapatan,
    required String pengeluaran,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BukuKasDetailPage(title: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Kartu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                Text(
                  "Saldo Akhir: $saldoAkhir",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Detail Saldo
            Row(
              children: [
                _buildDetailItem("Saldo Sebelumnya", saldoSebelumnya),
                _buildVerticalDivider(),
                _buildDetailItem("Pendapatan", pendapatan),
                _buildVerticalDivider(),
                _buildDetailItem("Pengeluaran", pengeluaran),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}