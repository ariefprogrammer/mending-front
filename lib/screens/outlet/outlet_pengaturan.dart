import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class PengaturanOutletPage extends StatefulWidget {
  const PengaturanOutletPage({super.key});

  @override
  State<PengaturanOutletPage> createState() => _PengaturanOutletPageState();
}

class _PengaturanOutletPageState extends State<PengaturanOutletPage> {
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _deliveryUrlController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  // State untuk Switch (Sesuaikan dengan field database/backend)
  bool _allowMultipleServices = false;
  bool _allowDuplicateService = false;
  bool _inputPcsMandatory = false;
  bool _processBerurutan = false;
  bool _paymentFirst = false;
  bool _employeeUpdateData = false;

  // State untuk Radio & Tax
  String _roundingType = "Terdekat";
  bool _isTaxEnabled = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _taxController.dispose();
    _deliveryUrlController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentConfiguration(); 
  }

  Future<void> _fetchCurrentConfiguration() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      print("Outlet ID: $activeId");

      final response = await http.get(
        Uri.parse(ApiConstants.getOutletConfiguration(activeId!)), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final config = responseData['data'];

        if (config != null) {
          setState(() {
            // Mapping Boolean (API kamu mengirim true/false, jadi ini sudah aman)
            _allowMultipleServices = config['allow_multiple_services'] == true || config['allow_multiple_services'] == 1;
            _allowDuplicateService = config['allow_duplicate_service'] == true || config['allow_duplicate_service'] == 1;
            _inputPcsMandatory = config['input_total_pcs_mandatory'] == true || config['input_total_pcs_mandatory'] == 1;
            _processBerurutan = config['process_berurutan'] == true || config['process_berurutan'] == 1;
            _paymentFirst = config['payment_first'] == true || config['payment_first'] == 1;
            _employeeUpdateData = config['employee_update_data'] == true || config['employee_update_data'] == 1;

            // Mapping Radio & TextFields
            _roundingType = config['rounding_type'] ?? "Terdekat";
            
            // Handle angka/null untuk PPN
            _taxController.text = config['tax_percentage']?.toString() ?? "";
            
            // Handle URL antar jemput
            _deliveryUrlController.text = config['delivery_form_url'] ?? "";
          });
          
          print("--- DEBUG: UI BERHASIL DIISI DENGAN DATA API ---");
        }
      }
    } catch (e) {
      debugPrint("Error fetch config: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitConfiguration() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      if (activeId == null) throw "ID Outlet tidak ditemukan";

      final response = await http.post(
        Uri.parse(ApiConstants.configureOutlet(activeId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          // Mapping sesuai Validator di Laravel kamu
          'allow_multiple_services': _allowMultipleServices,
          'allow_duplicate_service': _allowDuplicateService,
          'input_total_pcs_mandatory': _inputPcsMandatory,
          'process_berurutan': _processBerurutan,
          'payment_first': _paymentFirst,
          'employee_update_data': _employeeUpdateData,
          'rounding_type': _roundingType,
          'rounding_multiple': 100, // Contoh default kelipatan pembulatan
          'is_tax_enabled': _taxController.text.isNotEmpty,
          'tax_type': 'PPN',
          'tax_percentage': double.tryParse(_taxController.text) ?? 0,
          'delivery_form_url': _deliveryUrlController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Konfigurasi disimpan"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        throw responseData['message'] ?? "Gagal menyimpan konfigurasi";
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
          'Pengaturan Outlet', //
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: _isLoading 
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar Switch Pengaturan
            _buildSwitchTile("Bisa banyak layanan berbeda dalam satu transaksi", _allowMultipleServices, (val) => setState(() => _allowMultipleServices = val)),
            _buildSwitchTile("Bisa menduplikasi layanan yang sama dalam satu transaksi", _allowDuplicateService, (val) => setState(() => _allowDuplicateService = val)),
            _buildSwitchTile("Wajib mengisi jumlah potong cucian setiap transaksi", _inputPcsMandatory, (val) => setState(() => _inputPcsMandatory = val)),
            _buildSwitchTile("Proses pengerjaan laundry harus berurutan", _processBerurutan, (val) => setState(() => _processBerurutan = val)),
            _buildSwitchTile("Wajib pelunasan sebelum menyelesaikan transaksi", _paymentFirst, (val) => setState(() => _paymentFirst = val)),
            _buildSwitchTile("Karyawan bisa mengubah nomor telepon dan kata sandi", _employeeUpdateData, (val) => setState(() => _employeeUpdateData = val)),

            const SizedBox(height: 24),
            const Text("Pembulatan Total Transaksi", style: TextStyle(fontSize: 14, color: Colors.black87)),
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
            _buildTextField(controller: _notaController, hint: "Default TRL/..."),

            const SizedBox(height: 16),
            _buildLabel("PPN/PPH"),
            _buildSuffixTextField(controller: _taxController, hint: "0", suffix: "%"),

            const SizedBox(height: 16),
            _buildLabel("Antar Jemput"),
            _buildCopyTextField(controller: _deliveryUrlController, hint: "https://mendinglaundry.app/..."),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitConfiguration,
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
          groupValue: _roundingType,
          activeColor: const Color(0xFF1E3A8A),
          onChanged: (val) => setState(() => _roundingType = val!),
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

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildSuffixTextField({required TextEditingController controller, required String hint, required String suffix}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
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

  Widget _buildCopyTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
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