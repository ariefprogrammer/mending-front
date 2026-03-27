import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/ui_helpers.dart';

class MetodePembayaranPage extends StatefulWidget {
  const MetodePembayaranPage({super.key});

  @override
  State<MetodePembayaranPage> createState() => _MetodePembayaranPageState();
}

class _MetodePembayaranPageState extends State<MetodePembayaranPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _metodeController = TextEditingController();

  List<dynamic> _revenueCategories = [];
  List<dynamic> _costCategories = []; // List khusus pengeluaran
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listener untuk fetch data otomatis saat tab berpindah
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _refreshCurrentTabData();
    });
    _fetchAllData(); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    _metodeController.dispose();
    super.dispose();
  }

  // --- 1. GET DATA (READ) ---
  Future<void> _fetchAllData() async {
    await Future.wait([
      _fetchRevenueCategories(),
      _fetchCostCategories(),
    ]);
  }

  void _refreshCurrentTabData() {
    if (_tabController.index == 0) {
      _fetchRevenueCategories();
    } else {
      _fetchCostCategories();
    }
  }

  Future<void> _fetchRevenueCategories() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.get(
        Uri.parse(ApiConstants.revenueCategories(activeId!)),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() => _revenueCategories = responseData['data']);
      }
    } catch (e) {
      debugPrint("Error Revenue: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCostCategories() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final response = await http.get(
        Uri.parse(ApiConstants.costCategories(activeId!)),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() => _costCategories = responseData['data']);
      }
    } catch (e) {
      debugPrint("Error Cost: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. STORE DATA (CREATE) ---
  Future<void> _handleStore() async {
    if (_metodeController.text.isEmpty) return;
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      // Pilih URL berdasarkan Tab aktif
      final url = _tabController.index == 0 
          ? ApiConstants.revenueCategories(activeId!) 
          : ApiConstants.costCategories(activeId!);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": _metodeController.text}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        _metodeController.clear();
        _refreshCurrentTabData();
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Berhasil disimpan");
      } else {
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Gagal menyimpan", isError: true);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      UiHelpers.showSnackBar(context, "Terjadi kesalahan koneksi", isError: true);
      setState(() => _isLoading = false);
    }
  }

  // --- 3. UPDATE DATA ---
  Future<void> _handleUpdate(int id) async {
    if (_metodeController.text.isEmpty) return;
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final url = _tabController.index == 0 
          ? ApiConstants.revenueCategoryAction(activeId!, id)
          : ApiConstants.costCategoryAction(activeId!, id);

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"name": _metodeController.text}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _metodeController.clear();
        _refreshCurrentTabData();
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Data diperbarui");
      } else {
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Gagal", isError: true);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      UiHelpers.showSnackBar(context, "Kesalahan sistem", isError: true);
      setState(() => _isLoading = false);
    }
  }

  // --- 4. DELETE DATA ---
  Future<void> _handleDelete(int id) async {
    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final int? activeId = prefs.getInt('active_outlet_id');

      final url = _tabController.index == 0 
          ? ApiConstants.revenueCategoryAction(activeId!, id)
          : ApiConstants.costCategoryAction(activeId!, id);

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _refreshCurrentTabData();
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Berhasil dihapus");
      } else {
        UiHelpers.showSnackBar(context, responseData['message'] ?? "Gagal menghapus", isError: true);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      UiHelpers.showSnackBar(context, "Terjadi kesalahan", isError: true);
      setState(() => _isLoading = false);
    }
  }

  // 1. Fungsi Bottom Sheet untuk Tambah/Edit
  void _showFormBottomSheet({int? id, String? initialValue}) {
    _metodeController.text = initialValue ?? "";
    // if (initialValue != null) _metodeController.text = initialValue;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(initialValue == null ? "Tambah Metode" : "Ubah Metode", 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("Metode Pembayaran", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _metodeController,
              decoration: InputDecoration(
                hintText: "Ex : Tunai",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => id == null ? _handleStore() : _handleUpdate(id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 2. Fungsi Modal Peringatan Hapus
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
              Text("Apakah Anda yakin ingin menghapus metode $title?", textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              const Text("Data yang dihapus tidak bisa dipulihkan kembali", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
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
                      onPressed: () => _handleDelete(id),
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Pengaturan Metode Pembayaran', style: TextStyle(color: Colors.black, fontSize: 16)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          indicatorColor: const Color(0xFF1E3A8A),
          tabs: const [Tab(text: "Pendapatan"), Tab(text: "Pengeluaran")],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : TabBarView(
        controller: _tabController,
        children: [
              _buildMetodeList(_revenueCategories, "pendapatan"),
              _buildMetodeList(_costCategories, "pengeluaran"),
            ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showFormBottomSheet(), //
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Buat Metode Pembayaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMetodeList(List<dynamic> data, String type) {
    if (data.isEmpty) return Center(child: Text("Belum ada data $type"));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
          child: ListTile(
            title: Text(item['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.orange, size: 20), 
                  onPressed: () => _showFormBottomSheet(id: item['id'], initialValue: item['name'])),
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), 
                  onPressed: () => _showDeleteDialog(item['id'], item['name'])),
              ],
            ),
          ),
        );
      },
    );
  }
}