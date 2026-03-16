import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanPeralatanProduksiPage extends StatefulWidget {
  const LaporanPeralatanProduksiPage({super.key});

  @override
  State<LaporanPeralatanProduksiPage> createState() => _LaporanPeralatanProduksiPageState();
}

class _LaporanPeralatanProduksiPageState extends State<LaporanPeralatanProduksiPage> {
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
              primary: Color(0xFF1E3A8A), // Warna Navy sesuai tema
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
          'Laporan Penggunaan Bahan', //
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
          // Bagian Filter Tanggal
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
          
          // Daftar Peralatan
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildEquipmentCard("Mesin Cuci 1", "Pencucian", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Mesin Cuci 2", "Pencucian", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Mesin Cuci 3", "Pencucian", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Mesin Pengering 1", "Pengeringan", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Mesin Pengering 2", "Pengeringan", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Mesin Pengering 3", "Pengeringan", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Meja Setrika 1", "Setrika, lipat, kemas", "50 Kg | 52 Pcs | 8 Set"),
                _buildEquipmentCard("Meja Setrika 2", "Setrika, lipat, kemas", "50 Kg | 52 Pcs | 8 Set"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(String name, String process, String load) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name, //
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                load, //
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Proses: $process", //
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ],
      ),
    );
  }
}