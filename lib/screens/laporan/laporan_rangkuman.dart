import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanRangkumanPage extends StatefulWidget {
  const LaporanRangkumanPage({super.key});

  @override
  State<LaporanRangkumanPage> createState() => _LaporanRangkumanPageState();
}

class _LaporanRangkumanPageState extends State<LaporanRangkumanPage> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 1),
    end: DateTime(2025, 1, 31, 19, 25),
  );

  String _formatRange(DateTimeRange range) {
    final DateFormat formatter = DateFormat('dd MMM', 'id_ID');
    final DateFormat yearFormatter = DateFormat('yyyy, HH:mm', 'id_ID');
    return "${formatter.format(range.start)} - ${formatter.format(range.end)} ${yearFormatter.format(range.end)}";
  }

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
          'Rangkuman Laporan', //
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectDateRange(context),
              borderRadius: BorderRadius.circular(10),
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
                      _formatRange(_selectedDateRange), 
                      style: const TextStyle(fontSize: 14)
                    ),
                    const Icon(
                      Icons.calendar_today_outlined, 
                      color: Colors.grey, 
                      size: 20
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // LABA RUGI
            const Text("Laba Rugi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildRow("Total Pendapatan", "Rp 100.000.000"),
            _buildRow("Total Pengeluaran", "Rp 20.450.000"),
            _buildRow("Total Keuntungan Cabang", "Rp 79.550.000", isBold: false, color: const Color(0xFF1E3A8A)),
            const SizedBox(height: 10),
            const Divider(thickness: 1, height: 30, color: Colors.grey),

            // PENDAPATAN
            const Text("Pendapatan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildRow("Layanan", "Rp 50.000.000"),
            _buildRow("Deposit", "Rp 30.000.000"),
            _buildRow("Penjualan Aset", "Rp 15.000.000"),
            _buildRow("Penyewaan Aset", "Rp 4.900.000"),
            _buildRow("Penjualan Barang Bekas", "Rp 50.000"),
            _buildRow("Lain-lain", "Rp 50.000"),
            _buildRow("Total Pendapatan", "Rp 100.0000.000", isBold: false, color: const Color(0xFF1E3A8A)),
            const SizedBox(height: 10),
            const Divider(thickness: 1, height: 30, color: Colors.grey),

            // PENGELUARAN
            const Text("Pengeluaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildRow("Operasinal", "Rp 0"),
            _buildRow("Gaji", "Rp 10.000.000"),
            _buildRow("Sewa", "Rp 4.200.000"),
            _buildRow("Listrik", "Rp 1.500.000"),
            _buildRow("Air", "Rp 500.000"),
            _buildRow("Deterjen", "Rp 1.000.000"),
            _buildRow("Softener", "Rp 1.000.000"),
            _buildRow("Parfum", "Rp 500.000"),
            _buildRow("Plastik", "Rp 1.500.000"),
            _buildRow("Hanger Baju", "Rp 200.000"),
            _buildRow("Kertas Struk", "Rp 20.000"),
            _buildRow("Solasi", "Rp 30.000"),
            _buildRow("Perawatan", "Rp 0"),
            _buildRow("Perbaikan", "Rp 0"),
            _buildRow("Pembelian Aset", "Rp 0"),
            _buildRow("Lain-lain", "Rp 0"),
            _buildRow("Total Pengeluaran", "Rp 20.450.000", isBold: false, color: const Color(0xFF1E3A8A)),
            const SizedBox(height: 10),
            const Divider(thickness: 1, height: 30, color: Colors.grey),

            // METODE PEMBAYARAN
            const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildRow("Tunai", "Rp 80.000.000"),
            _buildRow("Deposit", "Rp 2.000.000"),
            _buildRow("Transfer", "Rp 3.000.000"),
            _buildRow("QRIS", "Rp 5.000.000"),
            _buildRow("Gopay", "Rp 2.000.000"),
            _buildRow("OVO", "Rp 2.000.000"),
            _buildRow("ShopeePay", "Rp 2.000.000"),
            _buildRow("Dana", "Rp 2.000.000"),
            _buildRow("LinkAja", "Rp 2.000.000"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? (color ?? Colors.black) : Colors.grey.shade700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}