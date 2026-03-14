// lib/screens/transaction_detail_page.dart
import 'package:flutter/material.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Detail Pesanan', //
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Info Pelanggan"), //
            _buildInfoCard([
              _buildRowInfo("Nama", "Donal Trump"),
              _buildRowInfo("No WhatsApp", "0816 1453 6321"),
            ]),

            _buildSectionHeader("Info Transaksi"), //
            _buildInfoCard([
              _buildRowInfo("ID Transaksi", "TRL/52134/2507/9999"),
              _buildRowInfo("Status", "Proses pengerjaan", valueColor: Colors.black87),
              _buildRowInfo("Kasir", "Zahra"),
              _buildRowInfo("Waktu Transaksi", "01 Jan 2025, 15:28"),
              _buildRowInfo("Estimasi Selesai", "02 Jan 2025, 15:28"),
              _buildRowInfo("Parfum", "-"),
              _buildRowInfo("Rak Penyimpanan", "-"),
              _buildRowInfo("Jumlah Kemasan", "-"),
            ]),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader("Layanan Laundry"), //
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0), // Padding vertikal nol
                    minimumSize: const Size(0, 30), // Mengatur tinggi minimal tombol jadi 30
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Menghilangkan margin tambahan di sekitar tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Tambah", 
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), // Font diperkecil sedikit agar proporsional
                  ),
                ),
              ],
            ),
            _buildServiceCard("Cuci Setrika (Kiloan)", "5,4 Kg x Rp 7.000 (5 Pcs)", "Rp 37.800"),
            _buildServiceCard("Cuci Setrika (Kiloan)", "1 Pcs x Rp 20.000 (5 Pcs)", "Rp 20.000"),

            _buildSectionHeader("Status Pembayaran"), //
            _buildInfoCard([
              _buildRowInfo("Metode Pembayaran", "Tunai"),
              _buildRowInfo("Waktu Pembayaran", "01 Jan 2025, 15:30"),
              _buildRowInfo("Kasir", "Ahmad Nurfaizi"),
            ]),

            _buildSectionHeader("Info Pembayaran"), //
            _buildInfoCard([
              _buildRowInfo("Subtotal", "Rp 100.000"),
              _buildRowInfo("Diskon", "Rp 10.000"),
              _buildRowInfo("PPN (%)", "20%"),
              _buildRowInfo("PPN (Rp)", "Rp 18.000"),
              _buildRowInfo("Pembulatan", "Rp 0"),
              const Divider(),
              _buildRowInfo("Total Transaksi", "Rp 108.000", isBold: true, valueColor: const Color(0xFF1E3A8A)),
            ]),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 15 : 13,
            color: valueColor ?? Colors.black,
          )),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String sub, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(price, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Icon(Icons.edit_note, color: Color(0xFF1E3A8A)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.download_for_offline, color: Colors.green, size: 20),
              const SizedBox(width: 4),
              const Icon(Icons.local_laundry_service, color: Colors.orange, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12)),
                child: const Text("Cuci", style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey, width: 0.1))),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1E3A8A)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Selesaikan", style: TextStyle(color: Color(0xFF1E3A8A))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showPaymentBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Bayar", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          )
        ],
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
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
            left: 20, right: 20, top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Judul & Close Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Proses Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bagian Total Transaksi & Pembulatan
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Total Transaksi", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 8),
                        Text("Rp 108.000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Setelah Pembulatan", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Rp0",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown Metode Pembayaran
              const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: "Tunai",
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: ["Tunai", "Transfer", "QRIS"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {},
              ),
              const SizedBox(height: 20),

              // Input Jumlah Dibayarkan & Shortcut
              const Text("Jumlah Dibayarkan", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Rp",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickAmount("Uang Pas"),
                    _buildQuickAmount("Rp 10.000"),
                    _buildQuickAmount("Rp 20.000"),
                    _buildQuickAmount("Rp 50.000"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Switch Deposit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Simpan uang kembalian sebagai deposit"),
                  Switch(value: false, onChanged: (val) {}),
                ],
              ),
              const SizedBox(height: 20),

              // Input Buku Kas
              const Text("Buku Kas", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Pendapatan (default)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 30),

              // Button Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Bayar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Batal"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAmount(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black54)),
      ),
    );
  }
}