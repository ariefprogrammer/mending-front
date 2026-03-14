import 'package:flutter/material.dart';

class PengaturanOutletPage extends StatefulWidget {
  const PengaturanOutletPage({super.key});

  @override
  State<PengaturanOutletPage> createState() => _PengaturanOutletPageState();
}

class _PengaturanOutletPageState extends State<PengaturanOutletPage> {
  // State untuk Switch
  bool _satuLayananSama = false;
  bool _satuLayananTransaksi = false;
  bool _wajibPotongCucian = false;
  bool _prosesBerurutan = false;
  bool _wajibPelunasan = false;
  bool _karyawanUbahData = false;

  // State untuk Radio Button Pembulatan
  String _pembulatan = "Terdekat";

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
          'Pengaturan Outlet', //
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
            // Daftar Switch Pengaturan
            _buildSwitchTile("Hanya bisa satu layanan yang sama pada setiap transaksi", _satuLayananSama, (val) => setState(() => _satuLayananSama = val)),
            _buildSwitchTile("Hanya bisa satu layanan pada setiap transaksi", _satuLayananTransaksi, (val) => setState(() => _satuLayananTransaksi = val)),
            _buildSwitchTile("Wajib mengisi jumlah potong cucian setiap transaksi", _wajibPotongCucian, (val) => setState(() => _wajibPotongCucian = val)),
            _buildSwitchTile("Proses pengerjaan laundry harus berurutan", _prosesBerurutan, (val) => setState(() => _prosesBerurutan = val)),
            _buildSwitchTile("Wajib pelunasan sebelum menyelesaikan transaksi", _wajibPelunasan, (val) => setState(() => _wajibPelunasan = val)),
            _buildSwitchTile("Karyawan bisa mengubah nomor telepon dan kata sandi", _karyawanUbahData, (val) => setState(() => _karyawanUbahData = val)),

            const SizedBox(height: 24),
            const Text("Pembulatan Total Transaksi", style: TextStyle(fontSize: 14, color: Colors.black87)), //
            const SizedBox(height: 8),
            
            // Radio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRadioItem("Terdekat"),
                _buildRadioItem("Ke atas"),
                _buildRadioItem("Ke bawah"),
              ],
            ),

            const SizedBox(height: 24),
            _buildLabel("ID Transaksi (Nomor Nota)"),
            _buildTextField(hint: "Default TRL/53722/31992/29202"), //

            const SizedBox(height: 16),
            _buildLabel("PPN/PPH"),
            _buildSuffixTextField(hint: "100", suffix: "%"), //

            const SizedBox(height: 16),
            _buildLabel("Antar Jemput"),
            _buildCopyTextField(hint: "https://mendinglaundry.app/..."), //

            const SizedBox(height: 40),
            SizedBox(
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)), //
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF1E3A8A),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title) {
    return Row(
      children: [
        Radio<String>(
          value: title,
          groupValue: _pembulatan,
          activeColor: const Color(0xFF1E3A8A),
          onChanged: (val) => setState(() => _pembulatan = val!),
        ),
        Text(title, style: const TextStyle(fontSize: 13)), //
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)), //
    );
  }

  Widget _buildTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildSuffixTextField({required String hint, required String suffix}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Text(suffix, style: const TextStyle(color: Colors.grey)), //
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildCopyTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Copy", style: TextStyle(color: Color(0xFF1E3A8A))), //
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}