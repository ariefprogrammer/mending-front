import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/ui_helpers.dart';

class UbahOutletPage extends StatefulWidget {
  const UbahOutletPage({super.key});

  @override
  State<UbahOutletPage> createState() => _UbahOutletPageState();
}

class _UbahOutletPageState extends State<UbahOutletPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String? _selectedProvinsi;
  String? _selectedKota;
  String? _selectedKecamatan;
  String? _selectedKelurahan;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchOriginalData();
  }

  Future<void> _fetchOriginalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.get(
        Uri.parse(ApiConstants.showOutlet(activeId!)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _idController.text = data['outlet_code'] ?? "";
          _namaController.text = data['name'] ?? "";
          _teleponController.text = data['phone'] ?? "";
          _alamatController.text = data['address'] ?? "";
          _selectedProvinsi = data['province'];
          _selectedKota = data['city'];
          _selectedKecamatan = data['kecamatan'];
          _selectedKelurahan = data['kelurahan'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      UiHelpers.showSnackBar(context, "Gagal memuat data: $e", isError: true);
    }
  }

  Future<void> _updateOutlet() async {
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.put(
        Uri.parse(ApiConstants.showOutlet(activeId!)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "name": _namaController.text,
          "phone": _teleponController.text,
          "province": _selectedProvinsi,
          "city": _selectedKota,
          "kecamatan": _selectedKecamatan,
          "kelurahan": _selectedKelurahan,
          "address": _alamatController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedData = responseData['data'];
      
        await prefs.setString('active_outlet_name', updatedData['name'] ?? _namaController.text);

        if (!mounted) return;
        
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Data outlet berhasil diperbarui");
        
        Navigator.pop(context, true);
      } else {
        UiHelpers.showSnackBar(
          context, 
          responseData['message'] ?? "Gagal memperbarui data", 
          isError: true
        );
      }
    } catch (e) {
      UiHelpers.showSnackBar(context, "Terjadi kesalahan sistem", isError: true);
      debugPrint("Update Outlet Error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
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

            _buildLabel("Alamat Lengkap"),
                _buildTextField(_alamatController, hint: "Nama jalan, RT/RW, No. Rumah"),

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
            onPressed: _isSaving ? null : _updateOutlet,
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
          value: items.contains(value) ? value : null,
          isExpanded: true,
          hint: const Text("Pilih"),
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