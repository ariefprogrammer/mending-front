// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../screens/transaction_page.dart';
import '../screens/create_page.dart';
import '../screens/services_page.dart';
import '../screens/profile_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack( // Gunakan Stack agar tombol bisa melayang dan tetap bisa diklik
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // 1. Background Navbar Putih
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    onTap: () => _navigate(context, 0, const DashboardPage()),
                  ),
                  _buildNavItem(
                    icon: Icons.receipt_outlined,
                    selectedIcon: Icons.receipt,
                    label: 'Transaksi',
                    index: 1,
                    onTap: () => _navigate(context, 1, const TransactionPage()),
                  ),
                  
                  // Ruang kosong untuk tempat tombol melayang agar Row tetap simetris
                  const SizedBox(width: 65), 

                  _buildNavItem(
                    icon: Icons.inventory_2_outlined,
                    selectedIcon: Icons.inventory_2,
                    label: 'Layanan',
                    index: 3,
                    onTap: () => _navigate(context, 3, const ServicesPage()),
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Profil',
                    index: 4,
                    onTap: () => _navigate(context, 4, const ProfilePage()),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Tombol Add (+) yang benar-benar melayang dan bisa diklik
        Positioned(
          top: -30, // Mengatur posisi mengambang ke atas
          child: GestureDetector(
            onTap: () {
              // CreatePage biasanya tidak menggunakan pushReplacement agar bisa kembali
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35, // Ukuran ikon diperbesar sedikit
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Fungsi helper navigasi agar kode lebih bersih
  void _navigate(BuildContext context, int index, Widget page) {
    if (currentIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}