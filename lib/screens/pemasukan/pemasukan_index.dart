import 'package:flutter/material.dart';
import 'pemasukan_create.dart';

class PemasukanIndexPage extends StatefulWidget {
  const PemasukanIndexPage({super.key});

  @override
  State<PemasukanIndexPage> createState() => _PemasukanIndexPageState();
}

class _PemasukanIndexPageState extends State<PemasukanIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy Pemasukan
  final List<Map<String, dynamic>> _allPemasukan = [
    {"judul": "Penjualan Harian", "tanggal": "12 Maret 2026", "jumlah": "Rp 1.250.000", "kategori": "Penjualan"},
    {"judul": "Investasi Masuk", "tanggal": "10 Maret 2026", "jumlah": "Rp 5.000.000", "kategori": "Investasi"},
    {"judul": "Sewa Alat", "tanggal": "11 Maret 2026", "jumlah": "Rp 300.000", "kategori": "Lainnya"},
  ];

  List<Map<String, dynamic>> _filteredPemasukan = [];
  bool _isAscending = true;
  bool _isSorted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredPemasukan = List.from(_allPemasukan);
    _searchController.addListener(_onSearchChanged);

    // Listener untuk update UI tombol bawah saat pindah tab
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  void _onSearchChanged() {
    setState(() {
      _filteredPemasukan = _allPemasukan
          .where((item) => item['judul']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      if (_isSorted) _applySort();
    });
  }

  void _toggleSort() {
    setState(() {
      _isSorted = true;
      _isAscending = !_isAscending;
      _applySort();
    });
  }

  void _applySort() {
    _filteredPemasukan.sort((a, b) => _isAscending
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
          'Pemasukan',
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
            Tab(text: 'Pemasukan'),
            Tab(text: 'Kategori'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPemasukanTab(),
          _buildKategoriTab(),
        ],
      ),
    );
  }

  Widget _buildPemasukanTab() {
    return Column(
      children: [
        // Search Bar
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

        // Sort & Filter Row
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
              // Filter Dropdown 1
              _buildFilterDropdown("Semua Buku Kas"),
              const SizedBox(width: 8),
              // Filter Dropdown 2
              _buildFilterDropdown("Semua Kategori"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tombol Buat Pemasukan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PemasukanCreatePage(), // Mengarah ke halaman create
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Buat Pemasukan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),

        // List Result (Opsional untuk testing search)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPemasukan.length,
            itemBuilder: (context, index) {
              final item = _filteredPemasukan[index];
              return ListTile(
                title: Text(item['judul']),
                subtitle: Text("${item['kategori']} - ${item['tanggal']}"),
                trailing: Text(item['jumlah'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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
            Flexible(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87), overflow: TextOverflow.ellipsis)),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriTab() {
    // Data dummy sesuai desain
    final List<String> kategoriList = [
      "Penjualan Aset",
      "Penyewaan Aset",
      "Penjualan Barang Bekas",
      "Lain-lain",
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kategoriList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  kategoriList[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
        // Tombol Buat Kategori di bagian bawah
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan navigasi ke buat kategori jika ada
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A), // Biru brand
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Buat Kategori',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}