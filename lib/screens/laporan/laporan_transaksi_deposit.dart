import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanTransaksiDepositPage extends StatefulWidget {
  const LaporanTransaksiDepositPage({super.key});

  @override
  State<LaporanTransaksiDepositPage> createState() => _LaporanTransaksiDepositPageState();
}

class _LaporanTransaksiDepositPageState extends State<LaporanTransaksiDepositPage> {
  String selectedStatus = "Masuk";
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 4),
    end: DateTime(2025, 1, 31),
  );

  // Fungsi Date Range Picker agar filter berfungsi
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
          'Laporan Transaksi Deposit', //
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
          // Bagian Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
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
                      flex: 3,
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
                                items: ["Masuk", "Keluar"]
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
                const SizedBox(height: 20),
                // Ringkasan Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Transaksi: 49", style: TextStyle(fontWeight: FontWeight.w500)),
                    const Text(
                      "Rp 150.000",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A8A)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // List Kartu Transaksi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDepositCard(
                  "TRL/52134/2507/9999",
                  "Donal Trump",
                  "0812 3456 7889",
                  "Lunas",
                  "Rp 150.000",
                  const Color(0xFF2ECC71), // Warna Hijau Lunas
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepositCard(String id, String name, String phone, String status, String total, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text(phone, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(total, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}