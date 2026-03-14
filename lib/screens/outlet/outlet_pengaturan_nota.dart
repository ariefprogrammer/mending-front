import 'package:flutter/material.dart';
import 'outlet_nota_preview.dart';

class PengaturanNotaPage extends StatefulWidget {
  const PengaturanNotaPage({super.key});

  @override
  State<PengaturanNotaPage> createState() => _PengaturanNotaPageState();
}

class _PengaturanNotaPageState extends State<PengaturanNotaPage> {
  // State untuk Radio Button Header
  String _headerAlignment = "Tengah";

  // State untuk Switch Opsi Nota
  bool _showLogo = false;
  bool _showNamaOutlet = false;
  bool _showAlamatOutlet = false;
  bool _showNamaKasir = false;
  bool _showNamaPelanggan = false;
  bool _showKategoriLayanan = false;
  bool _showJumlahPotong = false;
  bool _showEstimasiSelesai = false;
  bool _showParfum = false;
  bool _showQrCode = false;
  bool _showPoweredBy = false;
  bool _showHeaderFisik = false;
  bool _showFooterFisik = false;
  bool _autoPotongNota = false;

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
          'Pengaturan Nota/Struk', //
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
            // Upload Foto Header
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Color(0xFF1E3A8A), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text("Header (Optional)", style: TextStyle(fontSize: 14, color: Colors.black87)),
            Row(
              children: [
                _buildRadioItem("Kiri"),
                _buildRadioItem("Tengah"),
                _buildRadioItem("Kanan"),
              ],
            ),

            const SizedBox(height: 16),
            const Text("Catatan Header", style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Text",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),

            const SizedBox(height: 20),
            // Daftar Switch Pengaturan
            _buildSwitchTile("Logo", _showLogo, (val) => setState(() => _showLogo = val)),
            _buildSwitchTile("Nama outlet", _showNamaOutlet, (val) => setState(() => _showNamaOutlet = val)),
            _buildSwitchTile("Alamat outlet", _showAlamatOutlet, (val) => setState(() => _showAlamatOutlet = val)),
            _buildSwitchTile("Nama kasir", _showNamaKasir, (val) => setState(() => _showNamaKasir = val)),
            _buildSwitchTile("Nama pelanggan", _showNamaPelanggan, (val) => setState(() => _showNamaPelanggan = val)),
            _buildSwitchTile("Kategori layanan", _showKategoriLayanan, (val) => setState(() => _showKategoriLayanan = val)),
            _buildSwitchTile("Jumlah potong cucian", _showJumlahPotong, (val) => setState(() => _showJumlahPotong = val)),
            _buildSwitchTile("Waktu estimasi selesai", _showEstimasiSelesai, (val) => setState(() => _showEstimasiSelesai = val)),
            _buildSwitchTile("Parfum", _showParfum, (val) => setState(() => _showParfum = val)),
            _buildSwitchTile("QR code", _showQrCode, (val) => setState(() => _showQrCode = val)),
            _buildSwitchTile("Powered by MendingLaundry kasir", _showPoweredBy, (val) => setState(() => _showPoweredBy = val)),
            _buildSwitchTile("Header pada nota fisik", _showHeaderFisik, (val) => setState(() => _showHeaderFisik = val)),
            _buildSwitchTile("Footer pada nota fisik", _showFooterFisik, (val) => setState(() => _showFooterFisik = val)),
            _buildSwitchTile("Otomatis potong nota (jika printer mendukung)", _autoPotongNota, (val) => setState(() => _autoPotongNota = val)),

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotaPreviewPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF1E3A8A)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Lihat Contoh Nota", style: TextStyle(color: Color(0xFF1E3A8A))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioItem(String title) {
    return Row(
      children: [
        Radio<String>(
          value: title,
          groupValue: _headerAlignment,
          activeColor: const Color(0xFF1E3A8A),
          onChanged: (val) => setState(() => _headerAlignment = val!),
        ),
        Text(title, style: const TextStyle(fontSize: 14)), //
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF1E3A8A), //
          ),
        ],
      ),
    );
  }
}