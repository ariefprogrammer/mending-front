import 'package:flutter/material.dart';

class MetodePembayaranPage extends StatefulWidget {
  const MetodePembayaranPage({super.key});

  @override
  State<MetodePembayaranPage> createState() => _MetodePembayaranPageState();
}

class _MetodePembayaranPageState extends State<MetodePembayaranPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _metodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // 1. Fungsi Bottom Sheet untuk Tambah/Edit
  void _showFormBottomSheet({String? initialValue}) {
    if (initialValue != null) _metodeController.text = initialValue;
    
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
                onPressed: () {
                  _metodeController.clear();
                  Navigator.pop(context);
                },
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
  void _showDeleteDialog(String title) {
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
                      onPressed: () => Navigator.pop(context),
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
      body: TabBarView(
        controller: _tabController,
        children: [_buildMetodeList(), _buildMetodeList()],
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

  Widget _buildMetodeList() {
    final List<String> daftarMetode = ["Tunai", "Transfer", "QRIS"];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarMetode.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(daftarMetode[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Edit
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.orange, size: 20),
                  onPressed: () => _showFormBottomSheet(initialValue: daftarMetode[index]),
                ),
                // Tombol Hapus
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => _showDeleteDialog(daftarMetode[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}