import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPendapatanPage extends StatefulWidget {
  const LaporanPendapatanPage({super.key});

  @override
  State<LaporanPendapatanPage> createState() => _LaporanPendapatanPageState();
}

class _LaporanPendapatanPageState extends State<LaporanPendapatanPage> {
  String selectedFilter = "Semua Pendapatan";
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
              primary: Color(0xFF1E3A8A), // Biru Navy Brand
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
          'Laporan Pendapatan', //
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Box Tanggal
                InkWell(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDateRange.start)} s/d ${DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDateRange.end)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Baris Urutkan dan Dropdown
                Row(
                  children: [
                    // Tombol Urutkan
                    InkWell(
                      onTap: () {},
                      child: const Column(
                        children: [
                          Icon(Icons.swap_vert, color: Colors.black87),
                          Text("Urutkan", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Dropdown Kategori Pendapatan
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: ["Semua Pendapatan", "Layanan", "Deposit", "Lain-lain"]
                                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
                                .toList(),
                            onChanged: (val) => setState(() => selectedFilter = val!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1, height: 1),

          // Area Daftar Pendapatan (Empty State placeholder)
          const Expanded(
            child: Center(
              child: Text(
                "Tidak ada data pendapatan",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}