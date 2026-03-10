import 'package:flutter/material.dart';
import 'karyawan_upah.dart';
import 'karyawan_izin_akses.dart';

class KaryawanCreatePage extends StatefulWidget {
  const KaryawanCreatePage({super.key});

  @override
  State<KaryawanCreatePage> createState() => _KaryawanCreatePageState();
}

class _KaryawanCreatePageState extends State<KaryawanCreatePage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
          'Buat Karyawan Baru',
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
            _buildFieldLabel("ID Karyawan (Terisi Otomatis)"),
            _buildTextField(hint: "UK - (ID Outlet) (No. Urut)", enabled: false),

            _buildFieldLabel("Jabatan/Posisi"),
            _buildDropdownField("Supervisor", ["Supervisor", "Kasir", "Setrika", "Kurir"]),

            _buildFieldLabel("Nama Lengkap"),
            _buildTextField(hint: "Rahadian"),

            _buildFieldLabel("No. WhatsApp"),
            _buildTextField(hint: "0839372910273", keyboardType: TextInputType.phone),

            _buildFieldLabel("Email"),
            _buildTextField(hint: "medaeng@gmail.com", keyboardType: TextInputType.emailAddress),

            _buildFieldLabel("Kata Sandi"),
            _buildTextField(
              hint: "12345",
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),

            _buildFieldLabel("Konfirmasi Kata Sandi"),
            _buildTextField(
              hint: "12345",
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),

            _buildFieldLabel("KTP"),
            _buildUploadButton("Unggah KTP"),

            _buildFieldLabel("NPWP"),
            _buildUploadButton("Unggah NPWP"),

            _buildFieldLabel("BPJS Kesehatan"),
            _buildUploadButton("Unggah BPJS Kesehatan"),

            _buildFieldLabel("BPJS Ketenagakerjaan"),
            _buildUploadButton("Unggah BPJS Ketenagakerjaan"),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KaryawanUpahPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12), // Agar efek klik rapi sesuai bentuk tombol
                    child: _buildActionSubButton("Upah", const Color(0xFFFFF4E5), const Color(0xFFF59E0B)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KaryawanIzinAksesPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: _buildActionSubButton("Izin Akses", const Color(0xFFFFEBD5), const Color(0xFFF59E0B)),
                  ),
                ),
                const SizedBox(width: 12),
                _buildMoreButton(),
              ],
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widgets sesuai gaya PresenTap
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF424242))),
    );
  }

  Widget _buildTextField({required String hint, bool enabled = true, bool obscureText = false, Widget? suffixIcon, TextInputType? keyboardType}) {
    return TextField(
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A8A))),
      ),
    );
  }

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

  Widget _buildUploadButton(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), // Note: Gunakan package dotted_border untuk hasil dash sempurna
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_outlined, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF424242))),
        ],
      ),
    );
  }

  Widget _buildActionSubButton(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.more_vert, color: Color(0xFF1E3A8A)),
    );
  }
}