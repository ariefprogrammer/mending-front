// lib/screens/auth_page.dart
import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import dashboard untuk navigasi

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
            onPressed: _isLoginChecked ? () {
              // Handle login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3878),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
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
            onPressed: _isRegisterChecked ? () {
              // Handle register
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3878),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Daftar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
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