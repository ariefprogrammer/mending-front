import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PesanMasalPage extends StatefulWidget {
  const PesanMasalPage({super.key});

  @override
  State<PesanMasalPage> createState() => _PesanMasalPageState();
}

class _PesanMasalPageState extends State<PesanMasalPage> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maksimal 5 gambar")),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  // Fungsi untuk menghapus gambar yang sudah dipilih
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Data Dummy untuk Dropdown Pelanggan
  String? _selectedCustomerGroup;
  final List<Map<String, String>> _customerGroups = [
    {'id': 'all', 'name': 'Semua Pelanggan (50.000)'},
    {'id': '1', 'name': 'Pelanggan Prioritas'},
    {'id': '2', 'name': 'Reseller Wilayah Lampung'},
    {'id': '3', 'name': 'Pelanggan Baru - Januari 2025'},
    {'id': '4', 'name': 'Grup Cuci Satuan'},
  ];

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
          'Pesan Masal',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fullscreen, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Penerima
            const Text("Penerima", style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildCustomerDropdown(),

            const SizedBox(height: 20),

            // Jeda Pengiriman
            const Text("Jeda Pengiriman Antar Kontak", style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildTextField(hint: "Per 5 detik"),

            const SizedBox(height: 20),

            // Lampiran Gambar/Dokumen
            const Text("Lampirkan Gambar/Dokumen", style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildAttachmentRow(),

            const SizedBox(height: 20),

            // Input Pesan
            const Text("Pesan", style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildMessageField(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      // Bottom Navigation untuk Info Kontak & Tombol Kirim
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildCustomerDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Pilih dari daftar pelanggan", style: TextStyle(color: Colors.grey)),
          value: _selectedCustomerGroup,
          items: _customerGroups.map((group) {
            return DropdownMenuItem<String>(
              value: group['id'],
              child: Text(group['name']!),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedCustomerGroup = val;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300), // Ganti Border.all jadi BorderSide
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300), // Gunakan BorderSide
        ),
      ),
    );
  }

  Widget _buildAttachmentRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tombol Tambah Gambar (+)
          InkWell(
            onTap: _pickImage,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Icons.add, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),

          // List Gambar yang terpilih
          ...List.generate(_selectedImages.length, (index) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_selectedImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Tombol Hapus (X) kecil di pojok gambar
                Positioned(
                  top: -2,
                  right: 5,
                  child: InkWell(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMessageField() {
    return TextField(
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "Teks",
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300), // Ganti Border.all jadi BorderSide
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300), // Gunakan BorderSide
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "50.000 Kontak Penerima",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Kirim", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}