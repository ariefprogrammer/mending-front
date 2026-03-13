import 'package:flutter/material.dart';
import 'bahan_create.dart';
import 'bahan_stock_detail.dart';

class BahanIndexPage extends StatefulWidget {
  const BahanIndexPage({super.key});

  @override
  State<BahanIndexPage> createState() => _BahanIndexPageState();
}

class _BahanIndexPageState extends State<BahanIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data Dummy Bahan
  final List<Map<String, dynamic>> _bahanList = [
    {"nama": "Detergen Rinso", "balance": "+2.150 ML", "stok_akhir": "8.400 ML"},
    {"nama": "Softener Molto", "balance": "+2.150 ML", "stok_akhir": "8.400 ML"},
    {"nama": "Kertas Struk", "balance": "+10 M", "stok_akhir": "400 M"},
    {"nama": "Solasi 24MM", "balance": "+20 M", "stok_akhir": "800 M"},
    {"nama": "Plastik Jinjing 30", "balance": "+2 Pcs", "stok_akhir": "8 Pcs"},
    {"nama": "Plastik Jinjing 35", "balance": "+2 Pcs", "stok_akhir": "84 Pcs"},
    {"nama": "Plastik Jinjing 40", "balance": "0 Pcs", "stok_akhir": "84 Pcs"},
  ];

  List<Map<String, dynamic>> _filteredBahan = [];

  bool _isAscending = true; 
  bool _isSorted = false;

  void _toggleSort() {
    setState(() {
      _isSorted = true;
      _isAscending = !_isAscending;
      _filteredBahan.sort((a, b) => _isAscending 
          ? a['nama']!.toLowerCase().compareTo(b['nama']!.toLowerCase()) 
          : b['nama']!.toLowerCase().compareTo(a['nama']!.toLowerCase()));
    });
  }

  // Data Dummy Stok Opname
  final List<Map<String, dynamic>> _stokOpnameList = [
    {
      "nama": "Ahmad Nurfaizi",
      "tanggal": "01 Januari 2025",
      "selisih_min": "3 Bahan",
      "selisih_plus": "8 Bahan",
    },
    {
      "nama": "Arief Hidayat",
      "tanggal": "07 Januari 2025",
      "selisih_min": "4 Bahan",
      "selisih_plus": "2 Bahan",
    },
  ];

  final TextEditingController _searchStokController = TextEditingController();
  List<Map<String, dynamic>> _filteredStokOpname = [];
  bool _isStokAscending = true;
  bool _isStokSorted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); 
      }
    });

    _filteredBahan = List.from(_bahanList);
    _searchController.addListener(_onSearchChanged);

    _filteredStokOpname = List.from(_stokOpnameList);
    _searchStokController.addListener(_onSearchStokChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredBahan = _bahanList
          .where((item) => item['nama']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();

      _filteredBahan.sort((a, b) => _isAscending 
        ? a['nama']!.toLowerCase().compareTo(b['nama']!.toLowerCase()) 
        : b['nama']!.toLowerCase().compareTo(a['nama']!.toLowerCase()));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchStokController.dispose();
    super.dispose();
  }

  void _onSearchStokChanged() {
    setState(() {
      _filteredStokOpname = _stokOpnameList
          .where((item) => item['nama']!
              .toLowerCase()
              .contains(_searchStokController.text.toLowerCase()))
          .toList();
      
      if (_isStokSorted) {
        _applyStokSort();
      }
    });
  }

  void _toggleStokSort() {
    setState(() {
      _isStokSorted = true;
      _isStokAscending = !_isStokAscending;
      _applyStokSort();
    });
  }

  void _applyStokSort() {
    _filteredStokOpname.sort((a, b) => _isStokAscending 
        ? a['nama']!.toLowerCase().compareTo(b['nama']!.toLowerCase()) 
        : b['nama']!.toLowerCase().compareTo(a['nama']!.toLowerCase()));
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
          'Bahan',
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
            Tab(text: 'Bahan'),
            Tab(text: 'Stok Opname'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBahanListTab(),
          _buildStokOpnameTab(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BahanCreatePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                _tabController.index == 0 ? 'Buat Bahan' : 'Buat Stok Opname',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBahanListTab() {
    return Column(
      children: [
        // Search & Sort Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
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
                      hintText: 'Cari Bahan',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _toggleSort, 
                child: Column(
                  children: [
                    Icon(
                      !_isSorted 
                          ? Icons.swap_vert // Ikon awal
                          : (_isAscending ? Icons.south : Icons.north), // Ikon setelah diklik
                      color: !_isSorted 
                          ? Colors.grey // Warna awal
                          : const Color(0xFF1E3A8A), // Warna biru brand setelah aktif
                      size: 20,
                    ),
                    const Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredBahan.length,
            itemBuilder: (context, index) {
              return _buildBahanCard(_filteredBahan[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBahanCard(Map<String, dynamic> item) {
    // Memberikan warna hijau pada balance jika positif
    bool isPositive = item['balance'].toString().startsWith('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item['nama']!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    const TextSpan(text: 'Balance: '),
                    TextSpan(
                      text: item['balance'],
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Stok Akhir: ${item['stok_akhir']}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStokOpnameTab() {
    return Column(
      children: [
        // Search & Sort Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchStokController,
                    decoration: InputDecoration(
                      hintText: 'Cari Stok Opname',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _toggleStokSort,
                child: Column(
                  children: [
                    Icon(
                      !_isStokSorted 
                          ? Icons.swap_vert 
                          : (_isStokAscending ? Icons.south : Icons.north),
                      color: !_isStokSorted ? Colors.grey : const Color(0xFF1E3A8A),
                      size: 20,
                    ),
                    const Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        ),
        // List Kartu Stok Opname
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredStokOpname.length,
            itemBuilder: (context, index) {
              return _buildStokOpnameCard(_filteredStokOpname[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStokOpnameCard(Map<String, dynamic> data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BahanStockDetailPage(namaPemeriksa: data['nama']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            // Baris Nama dan Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['nama'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  data['tanggal'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            // Baris Detail Selisih
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Kolom Selisih Negatif
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Total Selisih (-)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['selisih_min'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  // Garis Vertikal Pemisah
                  const VerticalDivider(thickness: 1, color: Colors.grey),
                  // Kolom Selisih Positif
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Total Selisih (+)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['selisih_plus'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}