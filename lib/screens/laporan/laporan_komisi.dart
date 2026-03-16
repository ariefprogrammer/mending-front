import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanKomisiPage extends StatefulWidget {
  const LaporanKomisiPage({super.key});

  @override
  State<LaporanKomisiPage> createState() => _LaporanKomisiPageState();
}

class _LaporanKomisiPageState extends State<LaporanKomisiPage> {
  String selectedFilter = "Komisi Karyawan";
  bool isAscending = true;
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 1),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporan Komisi', //
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
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Box Tanggal Memanjang
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
                    // Fitur Urutkan (Toggle Ascending/Descending)
                    InkWell(
                      onTap: () => setState(() => isAscending = !isAscending),
                      child: Column(
                        children: [
                          Icon(
                            isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                            color: Colors.black87,
                            size: 20,
                          ),
                          const Text("Urutkan", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Dropdown Kategori Komisi
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: ["Komisi Karyawan", "Komisi Referral", "Lain-lain"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, style: const TextStyle(fontSize: 14)),
                                    ))
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

          // Daftar Kartu Komisi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCommissionCard("UK-25049902", "Supervisor - Ahmad Nurfaizi"),
                _buildCommissionCard("UK-25049902", "Kasir - Rahadian"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionCard(String id, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            id, //
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            details, //
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}