import 'package:flutter/material.dart';
import 'pengeluaran_create.dart';

class PengeluaranIndexPage extends StatefulWidget {
  const PengeluaranIndexPage({super.key});

  @override
  State<PengeluaranIndexPage> createState() => _PengeluaranIndexPageState();
}

class _PengeluaranIndexPageState extends State<PengeluaranIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy Pengeluaran
  final List<Map<String, dynamic>> _allPengeluaran = [
    {"judul": "Pembelian Rinso Matic", "tanggal": "12 Maret 2026", "jumlah": "Rp 350.000", "kategori": "Detergen"},
    {"judul": "Sewa Gudang", "tanggal": "10 Maret 2026", "jumlah": "Rp 2.000.000", "kategori": "Operasional"},
    {"judul": "Listrik & Air", "tanggal": "11 Maret 2026", "jumlah": "Rp 500.000", "kategori": "Utilitas"},
  ];

  List<Map<String, dynamic>> _filteredPengeluaran = [];
  bool _isAscending = true;
  bool _isSorted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredPengeluaran = List.from(_allPengeluaran);
    _searchController.addListener(_onSearchChanged);
  }

  // Fungsi Pencarian
  void _onSearchChanged() {
    setState(() {
      _filteredPengeluaran = _allPengeluaran
          .where((item) => item['judul']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      if (_isSorted) _applySort();
    });
  }

  // Fungsi Toggle Urutkan
  void _toggleSort() {
    setState(() {
      _isSorted = true;
      _isAscending = !_isAscending;
      _applySort();
    });
  }

  void _applySort() {
    _filteredPengeluaran.sort((a, b) => _isAscending
        ? a['judul']!.toLowerCase().compareTo(b['judul']!.toLowerCase())
        : b['judul']!.toLowerCase().compareTo(a['judul']!.toLowerCase()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
          'Pengeluaran',
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
            Tab(text: 'Pengeluaran'),
            Tab(text: 'Kategori'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPengeluaranTab(),
          _buildKategoriTab(),
        ],
      ),
    );
  }

  Widget _buildPengeluaranTab() {
    return Column(
      children: [
        // Bar Pencarian
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        // Row Urutkan & Filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              InkWell(
                onTap: _toggleSort,
                child: Column(
                  children: [
                    Icon(
                      !_isSorted ? Icons.swap_vert : (_isAscending ? Icons.south : Icons.north),
                      color: !_isSorted ? Colors.grey : const Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    const Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown("Semua Buku Kas"),
              const SizedBox(width: 8),
              _buildFilterDropdown("Semua Kategori"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tombol Buat Pengeluaran
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PengeluaranCreatePage(), // Mengarah ke halaman create
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Buat Pengeluaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),

        // List Hasil Pengeluaran
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPengeluaran.length,
            itemBuilder: (context, index) {
              final item = _filteredPengeluaran[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item['judul'], style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text("${item['kategori']} • ${item['tanggal']}"),
                  trailing: Text(
                    item['jumlah'], 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red) // Merah untuk pengeluaran
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(text, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriTab() {
    // Data kategori sesuai desain terbaru
    final List<String> kategoriList = [
      "Operasional",
      "Gaji",
      "Sewa",
      "Listrik",
      "Air",
      "Detergen",
      "Softener",
      "Parfum",
      "Hanger Baju",
      "Kertas Struk",
    ];

    void _showAddKategoriSheet() {
      final TextEditingController _nameController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent, // Mengikuti rujukan
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan ikon close sesuai rujukan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                      const Text(
                        'Buat Kategori',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // Form Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Kategori", 
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama kategori',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isNotEmpty) {
                              // Logika simpan di sini
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kategoriList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        kategoriList[index],
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                          onPressed: () {
                            // Logika edit kategori
                          },
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          onPressed: () {
                            // Logika hapus kategori
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Tombol Buat Kategori yang sekarang memicu Bottom Sheet
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showAddKategoriSheet, // Panggil fungsi bottom sheet
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Buat Kategori',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ],
    );
  }

}