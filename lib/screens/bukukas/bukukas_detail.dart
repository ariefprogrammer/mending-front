import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model sederhana untuk transaksi
class Transaksi {
  final String title;
  final String subtitle;
  final int amount;
  final String desc;
  final DateTime date;
  final bool isPositive;

  Transaksi({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.desc,
    required this.date,
    required this.isPositive,
  });
}

class BukuKasDetailPage extends StatefulWidget {
  final String title;
  const BukuKasDetailPage({super.key, required this.title});

  @override
  State<BukuKasDetailPage> createState() => _BukuKasDetailPageState();
}

class _BukuKasDetailPageState extends State<BukuKasDetailPage> {
  // State Management
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime(2025, 1, 1),
    end: DateTime(2025, 1, 31),
  );
  bool _isAscending = false;

  // Data Dummy
  final List<Transaksi> _allTransactions = [
    Transaksi(
      title: "Transaksi",
      subtitle: "Kasir - Ahmad Nurfaizi",
      amount: 112000,
      desc: "Pendapatan dengan ID Trx TRL/4123/32323/3233",
      date: DateTime(2025, 1, 5, 18, 32),
      isPositive: true,
    ),
    Transaksi(
      title: "Pindah Saldo",
      subtitle: "Kasir - Ahmad Nurfaizi",
      amount: 50000000,
      desc: "Pindah saldo dari buku kas pendapatan",
      date: DateTime(2025, 1, 6, 10, 00),
      isPositive: true,
    ),
    Transaksi(
      title: "Pindah Saldo",
      subtitle: "Kasir - Ahmad Nurfaizi",
      amount: 1500000,
      desc: "Pindah saldo ke buku kas Petty Cash",
      date: DateTime(2025, 1, 7, 12, 00),
      isPositive: false,
    ),
  ];

  List<Transaksi> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _applyFilters();
  }

  // Fungsi Logika Filter, Search, dan Sort
  void _applyFilters() {
    setState(() {
      _filteredTransactions = _allTransactions.where((trx) {
        // Filter Search Deskripsi
        final matchesSearch = trx.desc.toLowerCase().contains(_searchController.text.toLowerCase()) || 
                             trx.title.toLowerCase().contains(_searchController.text.toLowerCase());
        
        // Filter Date Range
        final isWithinDate = trx.date.isAfter(_selectedDateRange.start.subtract(const Duration(days: 1))) &&
                            trx.date.isBefore(_selectedDateRange.end.add(const Duration(days: 1)));
        
        return matchesSearch && isWithinDate;
      }).toList();

      // Sort Berdasarkan Tanggal
      _filteredTransactions.sort((a, b) => _isAscending 
          ? a.date.compareTo(b.date) 
          : b.date.compareTo(a.date));
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1E3A8A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _selectedDateRange = picked;
      _applyFilters();
    }
  }

  String _formatCurrency(int amount, bool isPositive) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return "${isPositive ? '+' : '-'}${format.format(amount)}";
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
        title: const Text('Detail Buku Kas', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildSortAndDatePicker(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 16),
                ..._filteredTransactions.map((trx) => _buildTransactionItem(
                  title: trx.title,
                  subtitle: "${trx.subtitle}\n${DateFormat('dd MMM yyyy, HH:mm').format(trx.date)}",
                  amount: _formatCurrency(trx.amount, trx.isPositive),
                  desc: trx.desc,
                  isPositive: trx.isPositive,
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _applyFilters(), // Trigger pencarian
        decoration: const InputDecoration(
          hintText: 'Cari Deskripsi',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSortAndDatePicker() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _isAscending = !_isAscending;
            _applyFilters(); // Trigger pengurutan
          },
          child: Column(
            children: [
              Icon(Icons.swap_vert, color: _isAscending ? const Color(0xFF1E3A8A) : Colors.grey),
              const Text('Urutkan', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => _selectDateRange(context), // Trigger date range
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateFormat('dd MMM').format(_selectedDateRange.start)} s/d ${DateFormat('dd MMM yyyy').format(_selectedDateRange.end)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget Summary Card dan Item (Tetap Sesuai Desain Sebelumnya) ---
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("Saldo Akhir", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  Text("Rp 243.500.000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleDetail("Saldo Sebelumnya", "Rp 195.000.000"),
              _buildSimpleDetail("Pendapatan", "Rp 50.000.000"),
              _buildSimpleDetail("Pengeluaran", "Rp 1.500.000"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTransactionItem({required String title, required String subtitle, required String amount, required String desc, required bool isPositive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(amount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4))),
              Expanded(flex: 3, child: Text(desc, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4))),
            ],
          ),
        ],
      ),
    );
  }
}