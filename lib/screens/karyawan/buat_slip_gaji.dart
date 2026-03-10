import 'package:flutter/material.dart';

class BuatSlipGajiPage extends StatefulWidget {
  const BuatSlipGajiPage({super.key});

  @override
  State<BuatSlipGajiPage> createState() => _BuatSlipGajiPageState();
}

class _BuatSlipGajiPageState extends State<BuatSlipGajiPage> {
  bool _isThrEnabled = false;
  bool _isCatatPengeluaran = false;

  // Data dummy untuk Buku Kas
  final List<String> _bukuKasList = [
    "Rekening Bank",
    "Kas Tunai",
    "Bank Mandiri - 1234xx",
    "Bank BCA - 5678xx"
  ];

  String _selectedBukuKas = "Rekening Bank";

  // State untuk menyimpan rentang tanggal
  DateTimeRange? _selectedDateRange;

  // Fungsi untuk memformat tampilan tanggal
  String _getFormattedDateRange() {
    if (_selectedDateRange == null) return "01 Feb - 28 Feb 2025";
    
    // Format sederhana: dd MMM
    String start = "${_selectedDateRange!.start.day} ${_getMonthName(_selectedDateRange!.start.month)}";
    String end = "${_selectedDateRange!.end.day} ${_getMonthName(_selectedDateRange!.end.month)} ${_selectedDateRange!.end.year}";
    return "$start - $end";
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
    return months[month - 1];
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
          'Buat Slip Gaji',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Buku Kas & Periode
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Buku Kas"),
                            _buildDropdownField(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Periode"),
                            _buildDatePickerField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Daftar Rincian Gaji Karyawan
                  _buildKaryawanGajiCard(
                    "Supervisor", 
                    "Ahmad Nurfaizi", 
                    "200 jam kerja, 25x hadir, 5x libur, 0x cuti, 0x sakit, 0x izin, 0x tidak hadi",
                    "Rp 3.000.000"
                  ),
                  _buildKaryawanGajiCard(
                    "Supervisor", 
                    "Ade Sumiati", 
                    "200 jam kerja, 25x hadir, 5x libur, 0x cuti, 0x sakit, 0x izin, 0x tidak hadi",
                    "Rp 3.000.000"
                  ),

                  const SizedBox(height: 16),
                  _buildLabel("Bonus Tambahan"),
                  _buildTextField("Rp 0"),

                  const SizedBox(height: 20),
                  
                  // Switch Options
                  _buildSwitchOption(
                    "Bonus THR (otomatis terhitung berdasarkan waktu bergabung)", 
                    _isThrEnabled, 
                    (val) => setState(() => _isThrEnabled = val)
                  ),
                  _buildSwitchOption(
                    "Catat sebagai pengeluaran", 
                    _isCatatPengeluaran, 
                    (val) => setState(() => _isCatatPengeluaran = val)
                  ),
                ],
              ),
            ),
          ),
          
          // Tombol Simpan
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildKaryawanGajiCard(String jabatan, String nama, String detail, String total) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(jabatan, style: const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Text(nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(detail, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Upah bersih", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBukuKas,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _bukuKasList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedBukuKas = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2030),
          initialDateRange: _selectedDateRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1E3A8A), // Warna brand PresenTap
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedDateRange = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_getFormattedDateRange(), style: const TextStyle(fontSize: 13)),
            const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildSwitchOption(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1E3A8A),
          ),
        ],
      ),
    );
  }
}