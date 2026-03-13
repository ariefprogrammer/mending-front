import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PengeluaranCreatePage extends StatefulWidget {
  const PengeluaranCreatePage({super.key});

  @override
  State<PengeluaranCreatePage> createState() => _PengeluaranCreatePageState();
}

class _PengeluaranCreatePageState extends State<PengeluaranCreatePage> {
  // State Management untuk Input
  DateTime _selectedDate = DateTime.now();
  String _selectedKategori = "Detergen";
  String _selectedSatuan = "Jerigen";
  String _selectedMetode = "Transfer";

  final TextEditingController _namaController = TextEditingController(text: "Superpro Rinso");
  final TextEditingController _kuantitasController = TextEditingController(text: "5");
  final TextEditingController _hargaController = TextEditingController(text: "70000");
  final TextEditingController _catatanController = TextEditingController();

  // Fungsi Date Picker interaktif
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1E3A8A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
          'Buat Pengeluaran', // Label spesifik pengeluaran
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Waktu Pengeluaran
            _buildLabel("Waktu Pengeluaran"),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDate)),
                    const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Container Grup Detail Pengeluaran
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          "Kategori Pengeluaran", 
                          _selectedKategori, 
                          ["Detergen", "Peralatan", "Operasional"],
                          (val) => setState(() => _selectedKategori = val!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          "Satuan", 
                          _selectedSatuan, 
                          ["Jerigen", "Pcs", "Box"],
                          (val) => setState(() => _selectedSatuan = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInputField("Nama Pengeluaran", _namaController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInputField("Kuantitas", _kuantitasController, isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _buildInputField("Harga Satuan", _hargaController, prefix: "Rp ", isNumber: true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metode Pembayaran
            _buildLabel("Metode Pembayaran"),
            _buildDropdownContainer(
              _selectedMetode, 
              ["Transfer", "Tunai", "Kas Kecil"],
              (val) => setState(() => _selectedMetode = val!),
            ),
            const SizedBox(height: 20),

            // Catatan
            _buildLabel("Catatan"),
            TextField(
              controller: _catatanController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Text",
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan dan Tambah Item
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF1E3A8A)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Tambah Item', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? prefix, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            prefixText: prefix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        _buildDropdownContainer(value, items, onChanged),
      ],
    );
  }

  Widget _buildDropdownContainer(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}