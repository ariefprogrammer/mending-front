import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanBukuKasBesarPage extends StatefulWidget {
  const LaporanBukuKasBesarPage({super.key});

  @override
  State<LaporanBukuKasBesarPage> createState() => _LaporanBukuKasBesarPageState();
}

class _LaporanBukuKasBesarPageState extends State<LaporanBukuKasBesarPage> {
  String selectedBank = "BRI";
  DateTime selectedDate = DateTime(2025, 1, 4);

  // Fungsi untuk memanggil Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
          'Laporan Buku Kas Besar',
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
                          const Text("Rekening Bank", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          _buildDropdownField(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tanggal", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          _buildDateField(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Saldo Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBalanceInfo("Saldo Sebelumnya", "Rp 420.000.000"),
                    _buildBalanceInfo("Saldo Akhir", "Rp 450.000.000", isRight: true),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),

          // Transaksi List
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem("Nurfaizi", "01 Jan 2025, 15:00", "+Rp 60.000", "Uang Masuk", true),
                _buildTransactionItem("Nurfaizi", "01 Jan 2025, 15:00", "-Rp 10.000", "Uang Keluar", false),
                _buildTransactionItem("Nurfaizi", "01 Jan 2025, 15:00", "+Rp 60.000", "Uang Masuk", true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedBank,
          isExpanded: true,
          items: ["BRI", "BCA", "Mandiri"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => selectedBank = val!),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
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

  Widget _buildBalanceInfo(String label, String value, {bool isRight = false}) {
    return Column(
      crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
      ],
    );
  }

  Widget _buildTransactionItem(String name, String date, String amount, String status, bool isMasuk) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF1E3A8A), // Biru Navy Brand
            child: const Text("NF", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w400)),
          subtitle: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isMasuk ? Colors.green : Colors.red, //
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(status, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}