import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPembayaranPage extends StatefulWidget {
  const LaporanPembayaranPage({super.key});

  @override
  State<LaporanPembayaranPage> createState() => _LaporanPembayaranPageState();
}

class _LaporanPembayaranPageState extends State<LaporanPembayaranPage> {
  String selectedStatus = "Lunas";
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 4),
    end: DateTime(2025, 1, 31),
  );

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
              primary: Color(0xFF1E3A8A),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporan Pembayaran', //
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Filter Tanggal
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tanggal", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat('d').format(_selectedDateRange.start)} - ${DateFormat('d MMM yyyy').format(_selectedDateRange.end)}",
                                style: const TextStyle(fontSize: 13),
                              ),
                              const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Status
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Status", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStatus,
                            isExpanded: true,
                            items: ["Lunas", "Belum Bayar", "Sebagian"]
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => selectedStatus = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          // Daftar Metode Pembayaran
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                const Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildPaymentRow("Tunai", "Rp 80.000.000"),
                _buildPaymentRow("Deposit", "Rp 2.000.000"),
                _buildPaymentRow("Transfer", "Rp 3.000.000"),
                _buildPaymentRow("QRIS", "Rp 5.000.000"),
                _buildPaymentRow("Gopay", "Rp 2.000.000"),
                _buildPaymentRow("OVO", "Rp 2.000.000"),
                _buildPaymentRow("ShopeePay", "Rp 2.000.000"),
                _buildPaymentRow("Dana", "Rp 2.000.000"),
                _buildPaymentRow("LinkAja", "Rp 2.000.000"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.black87, fontSize: 15)),
        ],
      ),
    );
  }
}