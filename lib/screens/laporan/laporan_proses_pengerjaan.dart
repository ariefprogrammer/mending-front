import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanProsesPengerjaanPage extends StatefulWidget {
  const LaporanProsesPengerjaanPage({super.key});

  @override
  State<LaporanProsesPengerjaanPage> createState() => _LaporanProsesPengerjaanPageState();
}

class _LaporanProsesPengerjaanPageState extends State<LaporanProsesPengerjaanPage> {
  String selectedStatus = "Semua Status";
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
          'Laporan Proses Pengerjaan', //
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
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
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
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        items: ["Semua Status", "Proses", "Selesai"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (val) => setState(() => selectedStatus = val!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),

          // List Data Statistik
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                _buildUnitSection("Kg", [
                  {"label": "Cuci", "value": "153 Kg"},
                  {"label": "Kering", "value": "48 Kg"},
                  {"label": "Setrika", "value": "48 Kg"},
                  {"label": "Lipat", "value": "40 Kg"},
                  {"label": "Kemas", "value": "20 Kg"},
                ]),
                _buildUnitSection("Pcs", [
                  {"label": "Cuci", "value": "8 Pcs"},
                  {"label": "Kering", "value": "7 Pcs"},
                  {"label": "Setrika", "value": "4 Pcs"},
                  {"label": "Lipat", "value": "2 Pcs"},
                  {"label": "Kemas", "value": "10 Pcs"},
                ]),
                _buildUnitSection("Set", [
                  {"label": "Cuci", "value": "5 Set"},
                  {"label": "Kering", "value": "4 Set"},
                  {"label": "Setrika", "value": "8 Set"},
                  {"label": "Lipat", "value": "2 Set"},
                  {"label": "Kemas", "value": "3 Set"},
                ]),
                _buildUnitSection("M²", [
                  {"label": "Cuci", "value": "8 M²"},
                  {"label": "Kering", "value": "3 M²"},
                  {"label": "Setrika", "value": "5 M²"},
                  {"label": "Lipat", "value": "7 M²"},
                  {"label": "Kemas", "value": "1 M²"},
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSection(String unitName, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Satuan (Kg, Pcs, dll)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey.shade50,
          child: Text(
            unitName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // Item List di bawah Satuan
        ...items.map((item) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['label']!, style: const TextStyle(color: Colors.black87)),
                      Text(item['value']!, style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            )),
      ],
    );
  }
}