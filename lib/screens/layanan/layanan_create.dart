import 'package:flutter/material.dart';

class LayananCreatePage extends StatefulWidget {
  const LayananCreatePage({super.key});

  @override
  State<LayananCreatePage> createState() => _LayananCreatePageState();
}

class _LayananCreatePageState extends State<LayananCreatePage> {
  bool _isPinned = false;

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
          'Buat Layanan Baru',
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
            _buildFieldLabel("ID Layanan (Otomatis Terisi)"),
            _buildTextField(hint: "IDL-(ID Outlet)-(No Urut)", enabled: false),

            _buildFieldLabel("Nama Layanan"),
            _buildTextField(hint: "Text"),

            _buildFieldLabel("Kategori Layanan"),
            _buildDropdownField(hint: "Kiloan", items: ["Kiloan", "Satuan", "Premium"]),

            _buildFieldLabel("Satuan Layanan"),
            _buildDropdownField(hint: "Kg", items: ["Kg", "Pcs", "Mtr"]),

            _buildFieldLabel("Harga Layanan"),
            _buildTextField(hint: "Rp", keyboardType: TextInputType.number),

            _buildFieldLabel("Durasi Layanan"),
            _buildDropdownField(hint: "Hari", items: ["Hari", "Jam"]),

            _buildFieldLabel("Jumlah Durasi Layanan"),
            _buildTextField(hint: "1", keyboardType: TextInputType.number),

            _buildFieldLabel("Minimal Kuantitas"),
            _buildTextField(hint: "Numerik", keyboardType: TextInputType.number),

            const SizedBox(height: 24),
            const Text(
              "Jumlah komisi yang diterima dalam proses pengerjaan layanan",
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Bagian Komisi dengan Checkbox
            _buildCommissionRow("Cuci"),
            _buildCommissionRow("Kering"),
            _buildCommissionRow("Setrika"),
            _buildCommissionRow("Lipat"),
            _buildCommissionRow("Kemas"),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sematkan Layanan", style: TextStyle(fontWeight: FontWeight.w500)),
                Switch(
                  value: _isPinned,
                  activeColor: const Color(0xFF1E3A8A),
                  onChanged: (value) {
                    setState(() {
                      _isPinned = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika simpan di sini
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black87)),
    );
  }

  Widget _buildTextField({required String hint, bool enabled = true, TextInputType? keyboardType}) {
    return TextField(
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String hint, required List<String> items}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
        ),
      ),
      hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {},
    );
  }

  Widget _buildCommissionRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Memberikan lebar tetap agar input field di kanannya sejajar sempurna
          SizedBox(
            width: 100, 
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: false,
                    onChanged: (val) {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          
          // Input field yang sekarang akan sejajar secara vertikal
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white, // Putih agar kontras dengan border
                borderRadius: BorderRadius.circular(12), // Radius disesuaikan dengan desain
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Text("Rp", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "0",
                        border: InputBorder.none,
                        isDense: true, // Menghilangkan padding internal tambahan
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  Text("/Kg", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}