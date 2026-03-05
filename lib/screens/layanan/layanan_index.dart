import 'package:flutter/material.dart';
import 'layanan_create.dart';

class LayananIndexPage extends StatefulWidget {
  const LayananIndexPage({super.key});

  @override
  State<LayananIndexPage> createState() => _LayananIndexPageState();
}

class _LayananIndexPageState extends State<LayananIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _selectedSort = 'A - Z'; // Default urutan

  // Contoh data layanan untuk demonstrasi sorting
  List<Map<String, dynamic>> _layananData = [
    {"title": "Cuci Setrika", "price": 7000, "isPinned": true, "desc": "Cuci - Keringkan - Setrika - Lipat - Kemas"},
    {"title": "Cuci Lipat", "price": 4000, "isPinned": true, "desc": "Cuci - Keringkan - Lipat - Kemas"},
    {"title": "Hanya Setrika", "price": 4000, "isPinned": true, "desc": "Setrika - Lipat - Kemas"},
    {"title": "Bed Cover (S)", "price": 20000, "isPinned": false, "desc": "Cuci - Keringkan - Setrika - Kemas"},
  ];

  void _sortData(String criteria) {
    setState(() {
      _selectedSort = criteria;
      if (criteria == 'A - Z') {
        _layananData.sort((a, b) => a['title'].compareTo(b['title']));
      } else if (criteria == 'Z - A') {
        _layananData.sort((a, b) => b['title'].compareTo(a['title']));
      } else if (criteria == 'Termurah-Termahal') {
        _layananData.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (criteria == 'Termahal-Termurah') {
        _layananData.sort((a, b) => b['price'].compareTo(a['price']));
      }
    });
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder( // Agar radio button bisa update di dalam modal
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Urutkan Berdasarkan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...['A - Z', 'Z - A', 'Termurah-Termahal', 'Termahal-Termurah', 'Berdasarkan Kategori']
                      .map((option) => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: _selectedSort,
                            activeColor: const Color(0xFF1E3A8A),
                            controlAffinity: ListTileControlAffinity.trailing, // Radio di kanan
                            onChanged: (value) {
                              setModalState(() => _selectedSort = value!);
                            },
                          ))
                      .toList(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _sortData(_selectedSort);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(String namaKategori) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Apakah Anda yakin ingin menghapus kategori '),
                    TextSpan(
                      text: '"$namaKategori"?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Tombol Tidak
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBF2FF),
                        side: const BorderSide(color: Color(0xFF1E3A8A), width: 0.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Ya
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika hapus di sini
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Ya',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFormKategori() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Buat Kategori Baru',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF424242)
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              _buildFieldLabel("Nama Kategori"),
              _buildTextField(hint: "Contoh: Pakaian Pria / Karpet"),
              
              const SizedBox(height: 24),
              
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Simpan', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Tombol Batalkan
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEBF2FF),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Batalkan', 
                    style: TextStyle(color: Color(0xFF1E3A8A))
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
          'Layanan',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1E3A8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1E3A8A),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Layanan'),
            Tab(text: 'Kategori'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLayananTab(),
          _buildKategoriTab(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          bool isLayananTab = _tabController.index == 0;

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                if (isLayananTab) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LayananCreatePage()),
                  );
                } else {
                  _showFormKategori();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  isLayananTab ? 'Buat Layanan Baru' : 'Buat Kategori Baru',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLayananTab() {
    return Column(
      children: [
        // Filter & Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Layanan',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Kategori Layanan", style: TextStyle(fontSize: 12)),
                    items: [],
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: _showSortModal, // Panggil fungsinya di sini
                child: Column(
                  children: const [
                    Icon(Icons.swap_vert, color: Colors.grey),
                    Text('Urutkan', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        ),

        // List Layanan
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _layananData.length,
            itemBuilder: (context, index) {
              final item = _layananData[index];
              return _buildLayananCard(
                item['title'],
                item['desc'],
                "Rp${item['price']}/Kg",
                "*Min. 3 Kg",
                item['isPinned'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLayananCard(String title, String desc, String price, String minOrder, bool isPinned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(price, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ),
              Text(minOrder, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Durasi 1 Hari", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Icon(Icons.push_pin, color: isPinned ? const Color(0xFF1E3A8A) : Colors.grey.shade300, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriTab() {
    // Data dummy sesuai gambar desain
    final List<String> kategoriList = [
      "Kiloan",
      "Pakaian",
      "Perlengkapan Tidur",
      "Perlengkapan Ibadah",
      "Perlengkapan Bayi",
      "Boneka",
      "Tas",
      "Tanpa Kategori",
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kategoriList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  kategoriList[index],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              // Ikon Hapus (Merah)
              IconButton(
                onPressed: () {
                  _showDeleteConfirmation(kategoriList[index]);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              // Ikon Edit (Biru Tua)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A8A)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(left: 8),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A8A))),
      ),
    );
  }
}