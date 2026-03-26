// lib/screens/auth_page.dart
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers for Login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  bool _isLoginPasswordVisible = false;
  bool _isLoginChecked = false;

  // Controllers for Register
  final TextEditingController _registerNamaController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();
  
  bool _isRegisterPasswordVisible = false;
  bool _isRegisterConfirmPasswordVisible = false;
  bool _isRegisterChecked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNamaController.dispose();
    _registerEmailController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Header
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2B3A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _tabController.index == 0 
                    ? 'Masuk untuk kelola bisnis laundry Anda'
                    : 'Daftar untuk kelola bisnis laundry Anda',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 25),
              
              // Custom Tab Bar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabController.index = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tabController.index == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _tabController.index == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: _tabController.index == 0 
                                    ? const Color(0xFF1E2B3A) 
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _tabController.index = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tabController.index == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _tabController.index == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: _tabController.index == 1 
                                    ? const Color(0xFF1E2B3A) 
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Form based on selected tab
              _tabController.index == 0 ? _buildLoginForm() : _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        const Text(
          'Email atau Nomor Telepon',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Color(0xFF1E2B3A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              hintText: 'Masukkan Email atau Nomor Telepon',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Password
        const Text(
          'Kata Sandi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E2B3A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _loginPasswordController,
            obscureText: !_isLoginPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Masukkan Kata Sandi',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  _isLoginPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _isLoginPasswordVisible = !_isLoginPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
        
        // Forgot Password
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              // Handle forgot password
            },
            child: const Text(
              'Lupa kata sandi?',
              style: TextStyle(
                color: Color(0xFF1D3878),
                fontSize: 14,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Terms & Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.6,
              child: Checkbox(
                value: _isLoginChecked,
                onChanged: (value) {
                  setState(() {
                    _isLoginChecked = value ?? false;
                  });
                },
                activeColor: const Color(0xFF1D3878),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    const TextSpan(
                      text: 'Dengan mengklik "Masuk", saya setuju dengan ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 134, 134, 135),
                        fontWeight: FontWeight.w400,
                      ),),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D3878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const TextSpan(
                      text: ' dan ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 134, 134, 135),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D3878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Login Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: (_isLoginChecked && !_isLoading) ? _handleLogin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3878),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (_loginEmailController.text.isEmpty || _loginPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": _loginEmailController.text,
          "password": _loginPasswordController.text,
        }),
      );

      // Debugging: Cetak respon untuk melihat struktur asli dari Laravel
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        
        String token = data['data']?['access_token']?.toString() ?? "";
        String userName = data['data']?['user']?['name']?.toString() ?? "User";

        print("Token yang akan disimpan: $token");

        await prefs.setString('token', token);
        await prefs.setString('name', userName);
        await prefs.setBool('is_logged_in', true);

        if (!mounted) return;
        
        // PERBAIKAN NAVIGASI: Gunakan callback kosong untuk memastikan tidak ada return type Null
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Email atau Password salah')),
        );
      }
    } catch (e) {
      print("Error Detail: $e"); // Cek di console log
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Register Form
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          'Nama Pemilik (sesuai KTP)',
          'Masukkan Nama Pemilik',
          _registerNamaController,
          filledWithBorder: true,
          addTopSpacing: false,
        ),
        _buildTextField(
          'Email',
          'Masukkan Email',
          _registerEmailController,
          filledWithBorder: true,
        ),
        _buildTextField(
          'Nomor Telepon',
          'Masukkan Nomor Telepon',
          _registerPhoneController,
          isPhone: true,
          filledWithBorder: true,
        ),
        _buildTextField(
          'Kata Sandi',
          'Masukkan Kata Sandi',
          _registerPasswordController,
          isPassword: true,
          isPasswordVisible: _isRegisterPasswordVisible,
          filledWithBorder: true,
          onVisibilityChanged: () {
            setState(() {
              _isRegisterPasswordVisible = !_isRegisterPasswordVisible;
            });
          },
        ),
        _buildTextField(
          'Konfirmasi Kata Sandi',
          'Konfirmasi Kata Sandi',
          _registerConfirmPasswordController,
          isPassword: true,
          isPasswordVisible: _isRegisterConfirmPasswordVisible,
          filledWithBorder: true,
          onVisibilityChanged: () {
            setState(() {
              _isRegisterConfirmPasswordVisible = !_isRegisterConfirmPasswordVisible;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Terms & Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.6,
              child: Checkbox(
                value: _isRegisterChecked,
                onChanged: (value) {
                  setState(() {
                    _isRegisterChecked = value ?? false;
                  });
                },
                activeColor: const Color(0xFF1D3878),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    const TextSpan(
                      text: 'Saya setuju dengan ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1D3878),
                          fontWeight: FontWeight.w400,
                        ),
                    ),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D3878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Syarat Ketentuan WashPro',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D3878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Register Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: (_isRegisterChecked && !_isLoading) ? _handleRegister : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3878),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading 
              ? const SizedBox(
                  height: 20, 
                  width: 20, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
              : const Text('Daftar', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
      // Validasi sederhana
      if (_registerPasswordController.text != _registerConfirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(ApiConstants.register),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "name": _registerNamaController.text,
            "email": _registerEmailController.text,
            "password": _registerPasswordController.text,
            "password_confirmation": _registerConfirmPasswordController.text,
            "phone": _registerPhoneController.text,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Berhasil Register
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrasi Berhasil! Silahkan Masuk.')),
          );
          _tabController.animateTo(0); // Pindah ke tab login
        } else {
          // Gagal (Validasi Laravel biasanya balikkan 422)
          final errorData = jsonDecode(response.body);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorData['message'] ?? 'Gagal mendaftar')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan koneksi: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isPhone = false,
    bool isPasswordVisible = false,
    bool filledWithBorder = false,
    bool addTopSpacing = true,
    VoidCallback? onVisibilityChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addTopSpacing ? const SizedBox(height: 16) : const SizedBox.shrink(),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Color(0xFF1E2B3A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: filledWithBorder ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: filledWithBorder ? Border.all(color: Colors.grey[300]!) : null,
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? !isPasswordVisible : false,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: isPassword ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400],
                ),
                onPressed: onVisibilityChanged,
              ) : null,
            ),
          ),
        ),
      ],
    );
  }
}