import 'package:flutter/material.dart';

class PengaturanNotifikasiPage extends StatefulWidget {
  const PengaturanNotifikasiPage({super.key});

  @override
  State<PengaturanNotifikasiPage> createState() => _PengaturanNotifikasiPageState();
}

class _PengaturanNotifikasiPageState extends State<PengaturanNotifikasiPage> {
  // State untuk switch dan controller setiap kategori pesan
  bool _isSedangDikerjakanActive = false;
  final TextEditingController _sedangDikerjakanController = TextEditingController();

  bool _isSiapDiambilActive = false;
  final TextEditingController _siapDiambilController = TextEditingController();

  bool _isTagihanBelumTerbayarActive = false;
  final TextEditingController _tagihanBelumTerbayarController = TextEditingController();

  bool _isPengingatBelumDiambilActive = false;
  final TextEditingController _pengingatBelumDiambilController = TextEditingController();

  bool _isSelesaiActive = false;
  final TextEditingController _selesaiController = TextEditingController();

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
          'Pengaturan Pesan Pemberitahuan', //
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNotificationSection(
              "Pesan Pemberitahuan Sedang Dikerjakan", 
              _isSedangDikerjakanActive, 
              _sedangDikerjakanController,
              (val) => setState(() => _isSedangDikerjakanActive = val),
            ),
            _buildNotificationSection(
              "Pesan Pemberitahuan Siap Diambil", 
              _isSiapDiambilActive, 
              _siapDiambilController,
              (val) => setState(() => _isSiapDiambilActive = val),
            ),
            _buildNotificationSection(
              "Pesan Pemberitahuan Tagihan Belum Terbayar", 
              _isTagihanBelumTerbayarActive, 
              _tagihanBelumTerbayarController,
              (val) => setState(() => _isTagihanBelumTerbayarActive = val),
            ),
            _buildNotificationSection(
              "Pesan Pemberitahuan Pengingat Belum Diambil", 
              _isPengingatBelumDiambilActive, 
              _pengingatBelumDiambilController,
              (val) => setState(() => _isPengingatBelumDiambilActive = val),
            ),
            _buildNotificationSection(
              "Pesan Pemberitahuan Transaksi Telah Diambil & Selesai", 
              _isSelesaiActive, 
              _selesaiController,
              (val) => setState(() => _isSelesaiActive = val),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Biru Brand
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(String title, bool isActive, TextEditingController controller, Function(bool) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87))),
            Switch(
              value: isActive,
              onChanged: onToggle,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF1E3A8A), //
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Text",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTagButton("{customer_name}", controller), //
              _buildTagButton("{id_transaction}", controller),
              _buildTagButton("{total_payment}", controller),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTagButton(String tag, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        onPressed: () {
          // Logika untuk menambahkan tag ke posisi kursor saat ini
          final text = controller.text;
          final selection = controller.selection;
          final newText = text.replaceRange(selection.start, selection.end, tag);
          controller.value = controller.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: selection.start + tag.length),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF1E3A8A)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(tag, style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 12)),
      ),
    );
  }
}