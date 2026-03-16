import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav_bar.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // State untuk data input
  String selectedCategory = "Pelanggan";
  String selectedPewangi = "Akasia";
  DateTime selectedEntryDate = DateTime.now();
  DateTime selectedFinishDate = DateTime.now();
  bool isDiscountActive = true;
  String discountType = "Nominal";
  bool isPaymentActive = false;

  // Fungsi Picker Tanggal & Waktu
  Future<void> _selectDateTime(BuildContext context, bool isEntryDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isEntryDate ? selectedEntryDate : selectedFinishDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isEntryDate ? selectedEntryDate : selectedFinishDate),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
          if (isEntryDate) {
            selectedEntryDate = newDateTime;
          } else {
            selectedFinishDate = newDateTime;
          }
        });
      }
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
          'Buat Pesanan Baru', //
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w400, 
            fontSize: 18
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Pengguna
            _buildLabel("Kategori Pengguna"),
            Row(
              children: [
                _buildRadioOption("Pelanggan"),
                const SizedBox(width: 20),
                _buildRadioOption("Rekanan"),
              ],
            ),
            const SizedBox(height: 20),

            // Nama Pengguna
            _buildLabel("Nama Pengguna"),
            _buildTextField(hint: "Hasna"),
            const SizedBox(height: 20),

            // Tanggal Transaksi
            _buildLabel("Tanggal Transaksi Masuk"),
            _buildDateField(selectedEntryDate, () => _selectDateTime(context, true)),
            const SizedBox(height: 20),
            _buildLabel("Tanggal Transaksi Selesai"),
            _buildDateField(selectedFinishDate, () => _selectDateTime(context, false)),
            const SizedBox(height: 20),

            // Pewangi
            _buildLabel("Pewangi"),
            _buildDropdownField(),
            const SizedBox(height: 20),

            // Diskon Section
            _buildLabel("Jumlah Diskon"),
            _buildTextField(hint: "Rp 6.000"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Diskon", style: TextStyle(color: Colors.grey)),
                Switch(
                  value: isDiscountActive, 
                  onChanged: (val) => setState(() => isDiscountActive = val),
                  activeColor: const Color(0xFF1E3A8A),
                ),
              ],
            ),
            Row(
              children: [
                _buildDiscountTypeOption("Persen"),
                const SizedBox(width: 20),
                _buildDiscountTypeOption("Nominal"),
                const Spacer(),
                _buildSmallValueBox("Rp 6.000"),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(thickness: 1),
            const SizedBox(height: 15),

            // Info Transaksi
            const Text("Info Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildInfoRow("Rincian", "3 Layanan"),
            _buildInfoRow("Subtotal", "Rp 36.000"),
            _buildInfoRow("Diskon", "Rp 6.000"),
            _buildInfoRow("PPN (%)", "11%"),
            _buildInfoRow("PPN (RP)", "Rp 3.960"),
            const SizedBox(height: 15),
            const Divider(thickness: 1),
            const SizedBox(height: 15),

            // Pembayaran Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pembayaran", style: TextStyle(color: Colors.grey)),
                Switch(
                  value: isPaymentActive, 
                  onChanged: (val) => setState(() => isPaymentActive = val),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F0FE),
                      side: const BorderSide(color: Color(0xFF1E3A8A)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Tambah Layanan", style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.w400)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: -1), //
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildRadioOption(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Row(
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
               color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildDateField(DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd MMMM yyyy, HH:mm').format(date)),
            const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPewangi,
          isExpanded: true,
          items: ["Akasia", "Philux", "Sakura"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => selectedPewangi = val!),
        ),
      ),
    );
  }

  Widget _buildDiscountTypeOption(String label) {
    bool isSelected = discountType == label;
    return GestureDetector(
      onTap: () => setState(() => discountType = label),
      child: Row(
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
               color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSmallValueBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}