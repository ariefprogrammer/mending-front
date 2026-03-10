import 'package:flutter/material.dart';

class KaryawanIzinAksesPage extends StatefulWidget {
  const KaryawanIzinAksesPage({super.key});

  @override
  State<KaryawanIzinAksesPage> createState() => _KaryawanIzinAksesPageState();
}

class _KaryawanIzinAksesPageState extends State<KaryawanIzinAksesPage> {
  final Map<String, List<Map<String, dynamic>>> _accessData = {
    "Dashboard": [
      {"name": "Lihat Outlet", "isChecked": false},
      {"name": "Pindah Outlet", "isChecked": false},
    ],
    "Pelanggan": [
      {"name": "Lihat pelanggan individu", "isChecked": false},
      {"name": "Lihat deposit", "isChecked": false},
      {"name": "Buat pelanggan individu", "isChecked": false},
      {"name": "Buat deposit", "isChecked": false},
      {"name": "Ubah pelanggan individu", "isChecked": false},
      {"name": "Ubah deposit", "isChecked": false},
      {"name": "Lihat pelanggan rekanan", "isChecked": false},
      {"name": "Batal deposit", "isChecked": false},
      {"name": "Buat pelanggan rekanan", "isChecked": false},
      {"name": "Hapus deposit", "isChecked": false},
      {"name": "Ubah pelanggan rekanan", "isChecked": false},
      {"name": "Hapus pelanggan rekanan", "isChecked": false},
    ],
    "Layanan": [
      {"name": "Lihat kategori layanan", "isChecked": false},
      {"name": "Lihat layanan", "isChecked": false},
      {"name": "Buat kategori layanan", "isChecked": false},
      {"name": "Buat layanan", "isChecked": false},
      {"name": "Ubah kategori layanan", "isChecked": false},
      {"name": "Ubah layanan", "isChecked": false},
      {"name": "Hapus kategori layanan", "isChecked": false},
      {"name": "Hapus layanan", "isChecked": false},
    ],
    "Karyawan": [
      {"name": "Lihat karyawan", "isChecked": false},
      {"name": "Lihat jabatan/divisi", "isChecked": false},
      {"name": "Buat karyawan", "isChecked": false},
      {"name": "Buat jabatan/divisi", "isChecked": false},
      {"name": "Ubah karyawan", "isChecked": false},
      {"name": "Ubah jabatan/divisi", "isChecked": false},
      {"name": "Hapus karyawan", "isChecked": false},
      {"name": "Hapus jabatan/divisi", "isChecked": false},
      {"name": "Buat upah karyawan", "isChecked": false},
      {"name": "Buat izin akses karyawan", "isChecked": false},
    ]
  };

  // Logika untuk mencentang/menghapus semua item dalam satu kategori
  void _toggleSelectAll(String category, bool isSelected) {
    setState(() {
      for (var item in _accessData[category]!) {
        item['isChecked'] = isSelected;
      }
    });
  }

  // Logika untuk mengecek apakah tombol "Pilih Semua" harus tercentang
  bool _isAllSelected(String category) {
    return _accessData[category]!.every((item) => item['isChecked'] == true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Izin Akses',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel("Sumber Impor Izin Akses Karyawan"),
                  _buildDropdownField("HRIS Sistem A", ["HRIS Sistem A", "Sistem B"]),
                  
                  const SizedBox(height: 24),
                  
                  // Render grup secara dinamis berdasarkan data Map
                  _buildAccessGroup("Dashboard", hasSelectAll: false),
                  _buildAccessGroup("Pelanggan"),
                  _buildAccessGroup("Layanan"),
                  _buildAccessGroup("Karyawan"),
                  
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          
          // Tombol Simpan di bagian bawah (Fixed)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika simpan data ke database/API di sini
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Group Izin Akses
  Widget _buildAccessGroup(String title, {bool hasSelectAll = true}) {
    final options = _accessData[title] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)
            ),
            if (hasSelectAll)
              GestureDetector(
                onTap: () => _toggleSelectAll(title, !_isAllSelected(title)),
                child: Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isAllSelected(title),
                        activeColor: const Color(0xFF1E3A8A),
                        onChanged: (val) => _toggleSelectAll(title, val ?? false),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text("Pilih Semua", style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5, // Disesuaikan agar teks tidak terpotong
            mainAxisSpacing: 2,
            crossAxisSpacing: 10,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  options[index]['isChecked'] = !options[index]['isChecked'];
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: options[index]['isChecked'],
                      activeColor: const Color(0xFF1E3A8A),
                      onChanged: (val) {
                        setState(() {
                          options[index]['isChecked'] = val ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      options[index]['name'], 
                      style: const TextStyle(fontSize: 12, color: Color(0xFF424242)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(thickness: 1, color: Color(0xFFF5F5F5)),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF424242))),
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
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }
}