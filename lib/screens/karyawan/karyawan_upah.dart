import 'package:flutter/material.dart';

class KaryawanUpahPage extends StatefulWidget {
  const KaryawanUpahPage({super.key});

  @override
  State<KaryawanUpahPage> createState() => _KaryawanUpahPageState();
}

class _KaryawanUpahPageState extends State<KaryawanUpahPage> {
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
          'Upah Karyawan',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel("Sumber Impor Upah Karyawan"),
            _buildDropdownField("-", ["-", "Sumber A", "Sumber B"]),

            _buildFieldLabel("Gaji Pokok"),
            _buildInputWithDropdown("Rp1.500.000", "Perbulan", ["Perbulan", "Perhari"]),

            _buildFieldLabel("Upah Lembur"),
            _buildInputWithSuffixText("Rp10.000", "/Jam"),

            const SizedBox(height: 16),
            _buildSectionHeader("Tunjangan", "Tambah Tunjangan"),
            _buildDynamicRow("Insentif Kehadiran", "Rp 0", "Perhari"),

            const SizedBox(height: 16),
            _buildSectionHeader("Potongan", "Tambah Potongan"),
            _buildDynamicRow("BPJS Ketenagakerjaan", "Rp 0", "Perbulan"),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logika simpan upah
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Label Input
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF424242))),
    );
  }

  // Helper: Dropdown Standard
  Widget _buildDropdownField(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  // Helper: Input dengan Dropdown di samping (Gaji Pokok)
  Widget _buildInputWithDropdown(String hint, String dropValue, List<String> dropItems) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(width: 1, height: 48, color: Colors.grey.shade300),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<String>(
                  value: dropValue,
                  items: dropItems.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (val) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Input dengan Teks Suffix (Upah Lembur)
  Widget _buildInputWithSuffixText(String hint, String suffix) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          Text(suffix, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  // Helper: Header Seksi dengan Link Tambah
  Widget _buildSectionHeader(String title, String actionLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF424242))),
        TextButton(
          onPressed: () {},
          child: Text(
            actionLabel,
            style: const TextStyle(color: Color(0xFF1E3A8A), decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  // Helper: Baris Dinamis untuk Tunjangan/Potongan
  Widget _buildDynamicRow(String nameHint, String priceHint, String periodValue) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: nameHint, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 13)))),
                Container(width: 1, height: 40, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)),
                Expanded(child: TextField(decoration: InputDecoration(hintText: priceHint, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 13)))),
                Container(width: 1, height: 40, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: periodValue,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    items: [periodValue].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.delete_outline, color: Colors.red),
      ],
    );
  }
}