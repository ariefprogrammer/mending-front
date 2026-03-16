import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanTransaksiLayananPage extends StatefulWidget {
  const LaporanTransaksiLayananPage({super.key});

  @override
  State<LaporanTransaksiLayananPage> createState() => _LaporanTransaksiLayananPageState();
}

class _LaporanTransaksiLayananPageState extends State<LaporanTransaksiLayananPage> {
  String selectedFilter = "Masuk";
  DateTime selectedDate = DateTime(2025, 1, 4);

  // Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
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
          'Laporan Transaksi Layanan', //
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
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Filter Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Transaksi", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 8),
                            _buildDropdownFilter(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tanggal", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 8),
                            _buildDateField(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Ringkasan Satuan
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "878,63 Kg | 25 Pcs | 11 Set | 112 M2",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Transaksi: 149", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const Text(
                        "Rp 450.000.000",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Kategori Layanan
            _buildExpandableCategory("Cuci Setrika", "Kiloan", "Rp 260.000", "37,75 Kg", isExpanded: true),
            _buildSimpleCategory("Cuci Kering", "Kiloan", "Rp 0", "0 Kg"),
            _buildSimpleCategory("Cuci Lipat", "Kiloan", "Rp 100.000", "5 Kg"),
            _buildSimpleCategory("Hanya Setrika", "Kiloan", "Rp 50.000", "16 Kg"),
            _buildSimpleCategory("Jas", "Kiloan", "Rp 30.000", "1 Pcs"),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildDropdownFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter,
          isExpanded: true,
          items: ["Masuk", "Keluar"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => selectedFilter = val!),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd Jan yyyy', 'id_ID').format(selectedDate)),
            const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCategory(String title, String subtitle, String total, String weight, {bool isExpanded = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        shape: const Border(),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF1E3A8A))),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(total, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
            Text(weight, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        children: [
          _buildTransactionDetail("TRL/52134/2507/9999", "Muh Fikri Firdaus", "Belum Bayar", Colors.red),
          _buildTransactionDetail("TRL/52134/2507/9999", "Muh Fikri Firdaus", "Dibayar Sebagian", Colors.orange),
          _buildTransactionDetail("TRL/52134/2507/9999", "Muh Fikri Firdaus", "Lunas", Colors.green),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTransactionDetail(String id, String name, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris ID dan Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.w500, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Baris Nama (Kiri) dan Tanggal (Kanan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
              const Text("03 Jan 2025, 16:45", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
            ],
          ),
          
          const SizedBox(height: 6),
          
          // Baris Nomor Telepon (Kiri) dan Tanggal Selesai (Kanan)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0812 3456 7889", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
              Text("04 Jan 2025, 16:45", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
            ],
          ),
          
          const SizedBox(height: 8),

          // Baris Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Text("Rp 150.000", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCategory(String title, String subtitle, String total, String weight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(total, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(weight, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}