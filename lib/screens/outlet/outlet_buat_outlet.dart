import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';

class BuatOutletPage extends StatefulWidget {
  const BuatOutletPage({super.key});

  @override
  State<BuatOutletPage> createState() => _BuatOutletPageState(); // Nama state disamakan
}

class _BuatOutletPageState extends State<BuatOutletPage> {
  // Controller untuk input text
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  bool _isLoading = false;

  // Nilai default untuk dropdown (Pastikan ada di dalam list items)
  String _selectedProvinsi = "Jawa Barat";
  String _selectedKota = "Bandung";
  String _selectedKecamatan = "Coblong"; // Tambah kecamatan sesuai payload
  String _selectedKelurahan = "Dago";

  @override
  void initState() {
    super.initState();
    _generateOutletCode();
  }

  // Fungsi generate 6 angka acak
  void _generateOutletCode() {
    var rng = Random();
    String code = '';
    for (var i = 0; i < 6; i++) {
      code += rng.nextInt(10).toString();
    }
    _idController.text = code;
  }

  Future<void> _simpanOutlet() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(ApiConstants.outlets),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "outlet_code": _idController.text,
          "name": _namaController.text,
          "phone": _teleponController.text,
          "province": _selectedProvinsi,
          "city": _selectedKota,
          "kecamatan": _selectedKecamatan,
          "kelurahan": _selectedKelurahan,
          "address": _alamatController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Outlet berhasil dibuat!")),
        );
        Navigator.pop(context, true);
      } 
      // 📍 PENANGANAN ERROR VALIDASI (422 Unprocessable Entity)
      else if (response.statusCode == 422) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String allErrors = "";

        // Loop untuk mengambil semua pesan error dari setiap field
        errorData.forEach((key, value) {
          if (value is List) {
            allErrors += "- ${value.join('\n- ')}\n";
          }
        });

        throw allErrors.trim(); // Lempar pesan ke blok catch
      } else {
        throw "Terjadi kesalahan: ${response.statusCode}";
      }
    } catch (e) {
      if (!mounted) return;
      // Tampilkan semua pesan error dalam satu SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          'Buat Outlet Baru',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Input
            _buildLabel("ID Outlet (Otomatis Terisi)"),
            _buildTextField(_idController, readOnly: true),

            _buildLabel("Nama Outlet"),
            _buildTextField(_namaController, hint: "Contoh: Mending Cuci Cabang Dago"),

            _buildLabel("Nomor Telepon"),
            _buildTextField(_teleponController, hint: "0812...", keyboardType: TextInputType.phone),

            _buildLabel("Provinsi"),
            _buildDropdown(
              value: _selectedProvinsi,
              items: ["Jawa Barat", "Jawa Tengah", "Jawa Timur"],
              onChanged: (val) => setState(() => _selectedProvinsi = val!),
            ),

            _buildLabel("Kota/Kabupaten"),
            _buildDropdown(
              value: _selectedKota,
              items: ["Bandung", "Bogor", "Bekasi"],
              onChanged: (val) => setState(() => _selectedKota = val!),
            ),

            _buildLabel("Kecamatan"),
            _buildDropdown(
              value: _selectedKecamatan,
              items: ["Coblong", "Cibeunying", "Lengkong"],
              onChanged: (val) => setState(() => _selectedKecamatan = val!),
            ),

            _buildLabel("Kelurahan/Desa"),
            _buildDropdown(
              value: _selectedKelurahan,
              items: ["Dago", "Cibiru", "Lembang"],
              onChanged: (val) => setState(() => _selectedKelurahan = val!),
            ),

            _buildLabel("Alamat Lengkap"),
            _buildTextField(_alamatController, hint: "Nama jalan, No. Rumah, Komplek", maxLines: 2),

            const SizedBox(height: 120), // Memberi ruang agar tidak tertutup button sheet
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _simpanOutlet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Simpan Outlet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint, bool readOnly = false, TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
    // Validasi agar tidak error "There should be exactly one item with value"
    String validatedValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validatedValue,
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