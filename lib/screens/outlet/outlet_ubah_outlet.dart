import 'package:flutter/material.dart';

class UbahOutletPage extends StatefulWidget {
  const UbahOutletPage({super.key});

  @override
  State<UbahOutletPage> createState() => _UbahOutletPageState();
}

class _UbahOutletPageState extends State<UbahOutletPage> {
  // Controller untuk input text
  final TextEditingController _idController = TextEditingController(text: "UR-250100004");
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController(text: "0812938392223");
  
  // Nilai default untuk dropdown
  String? _selectedProvinsi = "Jawa Barat";
  String? _selectedKota = "Bandung";
  String? _selectedKelurahan = "Lembang";
  String? _selectedAlamat = "Jalan jalan 002/001";

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
          'Ubah Data Outlet', //
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil Outlet
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey.shade400),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E3A8A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Input
            _buildLabel("ID Outlet (Otomatis Terisi)"),
            _buildTextField(_idController, readOnly: true),

            _buildLabel("Nama Outlet"),
            _buildTextField(_namaController, hint: "Text"),

            _buildLabel("Nomor Telepon"),
            _buildTextField(_teleponController, keyboardType: TextInputType.phone),

            _buildLabel("Provinsi"),
            _buildDropdown(
              value: _selectedProvinsi,
              items: ["Jawa Barat", "Jawa Tengah", "Jawa Timur"],
              onChanged: (val) => setState(() => _selectedProvinsi = val),
            ),

            _buildLabel("Kota/Kabupaten"),
            _buildDropdown(
              value: _selectedKota,
              items: ["Bandung", "Bogor", "Bekasi"],
              onChanged: (val) => setState(() => _selectedKota = val),
            ),

            _buildLabel("Kelurahan/Desa"),
            _buildDropdown(
              value: _selectedKelurahan,
              items: ["Lembang", "Cibiru", "Dago"],
              onChanged: (val) => setState(() => _selectedKelurahan = val),
            ),

            _buildLabel("Alamat (Nama jalan/Gang/Komplek)"),
            _buildDropdown(
              value: _selectedAlamat,
              items: ["Jalan jalan 002/001", "Jalan Merdeka No. 10"],
              onChanged: (val) => setState(() => _selectedAlamat = val),
            ),

            // Baris No/Blok, RT, RW
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("No/Blok"),
                      _buildTextField(TextEditingController(), hint: "Text"),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("RT"),
                      _buildTextField(TextEditingController(), hint: "Number", keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("RW"),
                      _buildTextField(TextEditingController(), hint: "Number", keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // Ruang untuk tombol simpan
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), //
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)), //
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint, bool readOnly = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}