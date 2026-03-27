import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class PengaturanBukuKasPage extends StatefulWidget {
  const PengaturanBukuKasPage({super.key});

  @override
  State<PengaturanBukuKasPage> createState() => _PengaturanBukuKasPageState();
}

class _PengaturanBukuKasPageState extends State<PengaturanBukuKasPage> {
  final TextEditingController _bukuKasController = TextEditingController();

  List<dynamic> _daftarBukuKas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCashBooks();
  }

  @override
  void dispose() {
    _bukuKasController.dispose();
    super.dispose();
  }

  // --- 1. GET DATA (READ) ---
  Future<void> _fetchCashBooks() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.get(
        Uri.parse(ApiConstants.cashBooks(activeId!)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _daftarBukuKas = responseData['data'];
        });
      }
    } catch (e) {
      _showSnackBar("Gagal memuat data: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. STORE DATA ---
  Future<void> _storeCashBook() async {
    if (_bukuKasController.text.isEmpty) return;
    
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.post(
        Uri.parse(ApiConstants.cashBooks(activeId!)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": _bukuKasController.text}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _bukuKasController.clear();
        _fetchCashBooks(); // Di dalam fetch sudah ada setState(loading = false)
        _showSnackBar("Buku kas berhasil dibuat");
      } else {
        // Jika status code bukan sukses (misal 422 atau 500)
        _showSnackBar("Gagal: ${jsonDecode(response.body)['message']}", isError: true);
        setState(() => _isLoading = false); // 👈 Matikan loading di sini
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan koneksi", isError: true);
      setState(() => _isLoading = false); // 👈 Dan di sini
    }
  }

  // --- 3. UPDATE DATA ---
  Future<void> _updateCashBook(int id) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.put(
        Uri.parse(ApiConstants.cashBookAction(activeId!, id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": _bukuKasController.text}),
      );

      if (response.statusCode == 200) {
        _bukuKasController.clear();
        _fetchCashBooks();
        _showSnackBar("Buku kas berhasil diperbarui");
      } else {
        _showSnackBar("Gagal memperbarui data", isError: true);
        setState(() => _isLoading = false); // 👈 Matikan loading
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan", isError: true);
      setState(() => _isLoading = false); // 👈 Matikan loading
    }
  }

  // --- 4. DELETE DATA ---
  Future<void> _deleteCashBook(int id) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.delete(
        Uri.parse(ApiConstants.cashBookAction(activeId!, id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _fetchCashBooks();
        _showSnackBar("Buku kas berhasil dihapus");
      } else {
        _showSnackBar("Gagal menghapus", isError: true);
        setState(() => _isLoading = false); // 👈 Matikan loading
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan", isError: true);
      setState(() => _isLoading = false); // 👈 Matikan loading
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  // 1. Bottom Sheet untuk Create & Update
  void _showFormBukuKas({int? id, String? initialValue}) {
    _bukuKasController.text = initialValue ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              initialValue == null ? "Buat Buku Kas" : "Ubah Buku Kas",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text("Nama Buku Kas", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _bukuKasController,
              decoration: InputDecoration(
                hintText: "Contoh: Kas Utama",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => id == null ? _storeCashBook() : _updateCashBook(id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 2. Dialog Konfirmasi Hapus
  void _showDeleteDialog(int id, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda yakin ingin menghapus $title?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Text(
                "Data buku kas yang dihapus tidak bisa dipulihkan kembali",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F7FF),
                        side: const BorderSide(color: Color(0xFFD1E2FF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Tidak", style: TextStyle(color: Color(0xFF1E3A8A))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _deleteCashBook(id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Ya", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          'Pengaturan Buku Kas', //
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _daftarBukuKas.isEmpty 
                    ? const Center(child: Text("Belum ada buku kas"))
                    : ListView.builder(
                      itemCount: _daftarBukuKas.length,
                        itemBuilder: (context, index) {
                        final item = _daftarBukuKas[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListTile(
                            title: Text(item['name'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.orange, size: 20),
                                  onPressed: () => _showFormBukuKas(id: item['id'], initialValue: item['name']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => _showDeleteDialog(item['id'], item['name']),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Tambahkan navigasi ke Detail Buku Kas jika perlu
                            },
                          ),
                        );
                      },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showFormBukuKas(), //
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Buat Buku Kas", //
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}