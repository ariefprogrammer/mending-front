import 'package:flutter/material.dart';

class AssetIndexPage extends StatefulWidget {
  const AssetIndexPage({super.key});

  @override
  State<AssetIndexPage> createState() => _AssetIndexPageState();
}

class _AssetIndexPageState extends State<AssetIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredAssets = [];
  bool _isAscending = true;

  // Data Dummy Peralatan Produksi
  final List<Map<String, String>> _peralatanProduksi = [
    {"nama": "Mesin Cuci 1", "proses": "Pencucian"},
    {"nama": "Mesin Cuci 2", "proses": "Pencucian"},
    {"nama": "Mesin Cuci 3", "proses": "Pencucian"},
    {"nama": "Mesin Pengering 1", "proses": "Pengeringan"},
    {"nama": "Mesin Pengering 2", "proses": "Pengeringan"},
    {"nama": "Mesin Pengering 3", "proses": "Pengeringan"},
    {"nama": "Mesin Setrika 1", "proses": "Setrika, lipat, dan kemas"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredAssets = List.from(_peralatanProduksi);
    _filteredAsetOutlet = List.from(_asetOutletList);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredAssets = _peralatanProduksi
          .where((asset) => asset['nama']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      
      // Jangan lupa filter juga untuk aset outlet jika perlu
      _filteredAsetOutlet = _asetOutletList
          .where((item) => item.toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
      
      // Urutkan Peralatan Produksi
      _filteredAssets.sort((a, b) => _isAscending 
          ? a['nama']!.compareTo(b['nama']!) 
          : b['nama']!.compareTo(a['nama']!));
      
      // Urutkan Aset Outlet
      _filteredAsetOutlet.sort((a, b) => _isAscending 
          ? a.compareTo(b) 
          : b.compareTo(a));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(BuildContext context, String assetName) {
    // Cari index di list utama
    int originalIndex = _peralatanProduksi.indexWhere(
      (asset) => asset['nama'] == assetName
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF424242),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Apakah Anda yakin ingin menghapus Peralatan Produksi '),
                      TextSpan(
                        text: '"$assetName"?',
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
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Hapus dari list utama
                            _peralatanProduksi.removeAt(originalIndex);
                            
                            // Hapus dari filtered list
                            _filteredAssets.removeWhere(
                              (asset) => asset['nama'] == assetName
                            );
                          });
                          
                          Navigator.pop(context);
                          
                          // Tampilkan notifikasi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Peralatan Produksi "$assetName" berhasil dihapus'),
                              backgroundColor: const Color(0xFF1E3A8A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ya',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBuatPeralatanSheet(BuildContext context) {
    // List status checkbox
    Map<String, bool> prosesStatus = {
      "Cuci": false,
      "Kering": false,
      "Setrika": false,
      "Lipat": false,
      "Kemas": false,
    };
    bool pilihSemua = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Menggunakan StatefulBuilder agar checkbox bisa dicentang
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                        const Text(
                          'Buat Peralatan Produksi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nama Mesin/Alat", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Nama Mesin/Alat',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Row Pilih Semua
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Proses Pengerjaan", style: TextStyle(color: Colors.grey)),
                            Row(
                              children: [
                                Checkbox(
                                  value: pilihSemua,
                                  activeColor: const Color(0xFF1E3A8A),
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      pilihSemua = value!;
                                      prosesStatus.updateAll((key, val) => value);
                                    });
                                  },
                                ),
                                const Text("Pilih Semua", style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        
                        // List Checkbox Dinamis
                        ...prosesStatus.keys.map((String key) {
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                prosesStatus[key] = !prosesStatus[key]!;
                                // Update status "Pilih Semua" jika semua dicentang manual
                                pilihSemua = prosesStatus.values.every((element) => element);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4), // Menghilangkan padding antar baris
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 32, // Membatasi lebar area checkbox agar teks lebih dekat
                                    child: Checkbox(
                                      value: prosesStatus[key],
                                      activeColor: const Color(0xFF1E3A8A),
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Merapatkan jarak internal checkbox
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Menghilangkan margin tambahan
                                      onChanged: (bool? value) {
                                        setModalState(() {
                                          prosesStatus[key] = value!;
                                          pilihSemua = prosesStatus.values.every((element) => element);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Jarak antara box dan teks
                                  Text(key, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ambil data yang dicentang untuk disimpan
                              List<String> selectedProses = [];
                              prosesStatus.forEach((key, value) {
                                if (value) selectedProses.add(key);
                              });
                              print("Proses terpilih: $selectedProses");
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      },
    );
  }

  void _showEditPeralatanSheet(BuildContext context, Map<String, String> assetData, int index) {
    final TextEditingController _namaController = TextEditingController(text: assetData['nama']);
    
    // List status checkbox berdasarkan data yang ada
    Map<String, bool> prosesStatus = {
      "Cuci": false,
      "Kering": false,
      "Setrika": false,
      "Lipat": false,
      "Kemas": false,
    };
    
    // Parse proses yang sudah ada
    String prosesValue = assetData['proses'] ?? '';
    List<String> prosesList = prosesValue.split(', ').map((e) => e.trim()).toList();
    
    // Set checkbox berdasarkan data yang ada
    prosesStatus.forEach((key, value) {
      if (prosesList.contains(key)) {
        prosesStatus[key] = true;
      }
    });
    
    bool pilihSemua = prosesStatus.values.every((element) => element);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                        const Text(
                          'Edit Peralatan Produksi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nama Mesin/Alat", 
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            hintText: 'Nama Mesin/Alat',
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
                        const SizedBox(height: 24),
                        
                        // Row Pilih Semua
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Proses Pengerjaan", 
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: pilihSemua,
                                  activeColor: const Color(0xFF1E3A8A),
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      pilihSemua = value!;
                                      prosesStatus.updateAll((key, val) => value);
                                    });
                                  },
                                ),
                                const Text("Pilih Semua", style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        
                        // List Checkbox Dinamis
                        ...prosesStatus.keys.map((String key) {
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                prosesStatus[key] = !prosesStatus[key]!;
                                pilihSemua = prosesStatus.values.every((element) => element);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 32,
                                    child: Checkbox(
                                      value: prosesStatus[key],
                                      activeColor: const Color(0xFF1E3A8A),
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (bool? value) {
                                        setModalState(() {
                                          prosesStatus[key] = value!;
                                          pilihSemua = prosesStatus.values.every((element) => element);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(key, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_namaController.text.isNotEmpty) {
                                // Ambil data yang dicentang
                                List<String> selectedProses = [];
                                prosesStatus.forEach((key, value) {
                                  if (value) selectedProses.add(key);
                                });
                                
                                String prosesText = selectedProses.join(', ');
                                
                                setState(() {
                                  // Update di list utama
                                  _peralatanProduksi[index] = {
                                    'nama': _namaController.text,
                                    'proses': prosesText,
                                  };
                                  
                                  // Update di filtered list
                                  int filteredIndex = _filteredAssets.indexWhere(
                                    (item) => item['nama'] == assetData['nama']
                                  );
                                  if (filteredIndex != -1) {
                                    _filteredAssets[filteredIndex] = {
                                      'nama': _namaController.text,
                                      'proses': prosesText,
                                    };
                                  }
                                });
                                
                                // Tampilkan notifikasi sukses
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Peralatan Produksi berhasil diupdate'),
                                    backgroundColor: const Color(0xFF1E3A8A),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                
                                Navigator.pop(context);
                              } else {
                                // Tampilkan error jika field kosong
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Nama mesin/alat tidak boleh kosong'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
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
                              'Update',
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
      },
    );
  }

  Widget _buildCheckboxItem(String label) {
    return Row(
      children: [
        Checkbox(
          value: false, 
          onChanged: (val) {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
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
          'Aset',
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
            Tab(text: 'Peralatan Produksi'),
            Tab(text: 'Aset Outlet'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssetListTab(_peralatanProduksi, "Peralatan Produksi"),
          _buildAsetOutletTab(),
        ],
      ),
      // Tombol Dinamis mengikuti Tab
      bottomNavigationBar: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          String buttonText = _tabController.index == 0 
              ? 'Buat Peralatan Produksi' 
              : 'Buat Aset Outlet';
          
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
                if (_tabController.index == 0) {
                  _showBuatPeralatanSheet(context);
                } else {
                  _showBuatAsetOutletSheet(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssetListTab(List<Map<String, String>> items, String type) {
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
                    decoration: InputDecoration(
                      hintText: 'Cari $type',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
                      _isAscending ? Icons.south : Icons.north, // Indikator arah urutan
                      color: const Color(0xFF1E3A8A), 
                      size: 20
                    ),
                    const Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: _filteredAssets.isEmpty 
            ? const Center(child: Text("Aset tidak ditemukan")) 
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredAssets.length,
                itemBuilder: (context, index) {
                  return _buildAssetCard(_filteredAssets[index]);
                },
              ),
        ),
      ],
    );
  }

  Widget _buildAssetCard(Map<String, String> item) {
    // Cari index asli di list utama
    int originalIndex = _peralatanProduksi.indexWhere(
      (asset) => asset['nama'] == item['nama']
    );
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama']!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "Proses: ${item['proses']}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, item['nama']!);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                onPressed: () {
                  // Panggil fungsi edit dengan data yang benar
                  _showEditPeralatanSheet(context, item, originalIndex);
                },
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A8A), size: 22),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab Aset Outlet
  final List<String> _asetOutletList = [
    "Bangku",
    "Kipas",
    "AC",
    "Pel",
    "Dan lain-lain",
  ];

  // State untuk pencarian Aset Outlet
  List<String> _filteredAsetOutlet = [];

  Widget _buildAsetOutletTab() {
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
                    controller: _searchController, // Gunakan controller yang sama
                    decoration: const InputDecoration(
                      hintText: 'Cari Aset Outlet',
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
                      _isAscending ? Icons.south : Icons.north,
                      color: const Color(0xFF1E3A8A), 
                      size: 20
                    ),
                    const Text('Urutkan', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: _filteredAsetOutlet.isEmpty 
            ? const Center(child: Text("Aset Outlet tidak ditemukan"))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredAsetOutlet.length,
                itemBuilder: (context, index) {
                  return _buildSimpleAssetCard(_filteredAsetOutlet[index]);
                },
              ),
        ),
      ],
    );
  }

  Widget _buildSimpleAssetCard(String nama) {
    // Cari index asli di list utama
    int originalIndex = _asetOutletList.indexOf(nama);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nama,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Panggil fungsi delete
                  _showDeleteConfirmationDialogOutlet(context, nama, originalIndex);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                splashRadius: 20,
              ),
              IconButton(
                onPressed: () {
                  // Panggil fungsi edit
                  _showEditAsetOutletSheet(context, nama, originalIndex);
                },
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A8A), size: 22),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBuatAsetOutletSheet(BuildContext context) {
    final TextEditingController _namaController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                    const Text(
                      'Buat Aset Outlet',
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
                      "Nama Mesin/Alat", 
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        hintText: 'Nama Mesin/Alat',
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
                          if (_namaController.text.isNotEmpty) {
                            // Tambahkan aset outlet baru ke list
                            setState(() {
                              _asetOutletList.add(_namaController.text);
                              _filteredAsetOutlet = List.from(_asetOutletList);
                            });
                            
                            // Tampilkan notifikasi sukses (opsional)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Aset Outlet "${_namaController.text}" berhasil ditambahkan'),
                                backgroundColor: const Color(0xFF1E3A8A),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            
                            Navigator.pop(context);
                          } else {
                            // Tampilkan error jika field kosong
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama aset outlet tidak boleh kosong'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
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

  void _showEditAsetOutletSheet(BuildContext context, String oldName, int index) {
    final TextEditingController _editController = TextEditingController(text: oldName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                    const Text(
                      'Edit Aset Outlet',
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
                      "Nama Mesin/Alat", 
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _editController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Nama Mesin/Alat',
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
                          if (_editController.text.isNotEmpty) {
                            setState(() {
                              // Update di list utama
                              _asetOutletList[index] = _editController.text;
                              
                              // Update di filtered list
                              int filteredIndex = _filteredAsetOutlet.indexOf(oldName);
                              if (filteredIndex != -1) {
                                _filteredAsetOutlet[filteredIndex] = _editController.text;
                              }
                            });
                            
                            // Tampilkan notifikasi sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Aset Outlet berhasil diupdate menjadi "${_editController.text}"'),
                                backgroundColor: const Color(0xFF1E3A8A),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            
                            Navigator.pop(context);
                          } else {
                            // Tampilkan error jika field kosong
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama aset outlet tidak boleh kosong'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
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
                          'Update',
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

  void _showDeleteConfirmationDialogOutlet(BuildContext context, String assetName, int index) {
    int originalIndex = _peralatanProduksi.indexWhere(
      (asset) => asset['nama'] == assetName
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF424242),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Apakah Anda yakin ingin menghapus Aset Outlet '),
                      TextSpan(
                        text: '"$assetName"?',
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
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Hapus dari list utama
                            _asetOutletList.removeAt(index);
                            
                            // Hapus dari filtered list
                            _filteredAsetOutlet.remove(assetName);
                          });
                          
                          Navigator.pop(context);
                          
                          // Tampilkan notifikasi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Aset Outlet "$assetName" berhasil dihapus'),
                              backgroundColor: const Color(0xFF1E3A8A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ya',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}