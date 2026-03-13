import 'package:flutter/material.dart';

class BahanCreatePage extends StatefulWidget {
  const BahanCreatePage({super.key});

  @override
  State<BahanCreatePage> createState() => _BahanCreatePageState();
}

class _BahanCreatePageState extends State<BahanCreatePage> {
  // Controller untuk input teks
  final TextEditingController _namaController = TextEditingController(text: "Rinso matic cair");
  final TextEditingController _minStokController = TextEditingController(text: "4500");
  final TextEditingController _stokAwalController = TextEditingController(text: "9000");

  // State untuk Dropdown
  String _selectedKategori = "Deterjen";
  String _selectedSatuan = "ML";

  final List<String> _kategoriList = ["Deterjen", "Pewangi", "Plastik", "ATK"];
  final List<String> _satuanList = ["ML", "Liter", "Pcs", "Meter", "Kg"];

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
          'Buat Bahan',
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
            _buildLabel("Nama Bahan"),
            _buildTextField(_namaController, "Masukkan nama bahan"),
            
            const SizedBox(height: 20),
            _buildLabel("Kategori"),
            _buildDropdownField(_selectedKategori, _kategoriList, (val) {
              setState(() => _selectedKategori = val!);
            }),

            const SizedBox(height: 20),
            _buildLabel("Satuan"),
            _buildDropdownField(_selectedSatuan, _satuanList, (val) {
              setState(() => _selectedSatuan = val!);
            }),

            const SizedBox(height: 20),
            _buildLabel("Minimal Stok Pengingat"),
            _buildTextField(_minStokController, "0", keyboardType: TextInputType.number),

            const SizedBox(height: 20),
            _buildLabel("Stok Awal"),
            _buildTextField(_stokAwalController, "0", keyboardType: TextInputType.number),

            const SizedBox(height: 24),
            // Tombol Konversi & Penggunaan
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton(
                    "Konversi Satuan", 
                    const Color(0xFFFFF3E0), 
                    const Color(0xFFE65100),
                    onTap: () => _showKonversiSatuanSheet(context), 
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSecondaryButton(
                    "Penggunaan Bahan", 
                    const Color(0xFFFFCC80), 
                    Colors.white,
                    onTap: () => _showPenggunaanBahanSheet(context),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            // Tombol Simpan Utama
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKonversiSatuanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  const Text(
                    'Konversi Satuan Bahan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Container Input Konversi
                  Stack(
                    children: [
                      // Garis Vertikal Indikator
                      Positioned( 
                        left: 5, // Sesuaikan agar lurus dengan titik
                        top: 50,
                        bottom: 70,
                        child: Container(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        children: [
                          _buildKonversiBox("Satuan", "Jerigen", "Kuantitas", "1", true),
                          const SizedBox(height: 16),
                          _buildKonversiBox("Satuan Akhir", "ML", "Kuantitas Akhir", "4500", false),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tombol Tambah Konversi
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                        backgroundColor: const Color(0xFFF0F4FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Tambah Konversi', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.w400)),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPenggunaanBahanSheet(BuildContext context) {
    final List<String> unitLabels = [
      "Per/Kg", "Per/Pcs", "Per/Set", "Per/Meter", "Per/Meter²", "Per/Meter³", "Per/Cm"
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  const Text(
                    'Penggunaan Bahan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // List Input Penggunaan
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ...unitLabels.map((label) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPenggunaanRow(label),
                    )).toList(),
                    
                    const SizedBox(height: 4),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPenggunaanRow(String label) {
    const double rowHeight = 42.0;
    return Row(
      children: [
        // Label Satuan (Kiri)
        Expanded(
          flex: 3,
          child: Container(
            height: rowHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 147, 146, 146)),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            child: Text(label, style: const TextStyle(color: Color.fromARGB(255, 47, 47, 47))),
          ),
        ),
        // Input Nilai (Tengah)
        Expanded(
          flex: 4,
          child: Container(
            height: rowHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color.fromARGB(255, 147, 146, 146)),
                bottom: BorderSide(color: Color.fromARGB(255, 147, 146, 146)),
              ),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        // Label Satuan Akhir (Kanan - ML)
        Expanded(
          flex: 1,
          child: Container(
            height: rowHeight,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 147, 146, 146)),
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
            ),
            child: const Text("ML", textAlign: TextAlign.center, style: TextStyle(color: Color.fromARGB(255, 47, 47, 47))),
          ),
        ),
      ],
    );
  }

  Widget _buildKonversiBox(String labelDropdown, String valDropdown, String labelText, String valText, bool isTop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Agar titik berada di pangkal atas box
      children: [
        // Titik Indikator
        Padding(
          padding: const EdgeInsets.only(top: 45), // Memberi jarak agar titik sejajar tengah box input
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD1E2FF)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(labelDropdown, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: valDropdown,
                            isExpanded: true,
                            items: [valDropdown].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (v) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(labelText, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: valText),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildDropdownField(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, Color bgColor, Color textColor, {VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap, // Sekarang menggunakan parameter onTap
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 13),
      ),
    );
  }
}