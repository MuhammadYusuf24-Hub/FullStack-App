import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/app_them.dart';
import 'package:flutter_application_1/Service/serviceapi.dart';
import 'register.dart';
import 'lupapass.dart';
import 'home_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool _loading  = false;
  bool _showPass = false;
  String _error  = '';

  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = ''; });

    final data = await ServiceApi.login(_emailCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;
    setState(() => _loading = false);

    if (data['status'] == 'success') {
      final user  = await ServiceApi.getCurrentUser();
      final admin = await ServiceApi.isAdmin();
      if (!mounted) return;

      if (admin) {
        // TODO: ganti dengan AdminDashboard() saat sudah dibuat
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Login sebagai Admin — dashboard admin belum dibuat'),
          backgroundColor: AppColors.green600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) => HomePage(user: user),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    } else {
      setState(() => _error = data['message'] ?? 'Login gagal. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Brand header ──────────────────────────────
                  _buildBrand(),
                  const SizedBox(height: 24),

                  // ── Card ──────────────────────────────────────
                  _buildCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        // Logo circle
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.blue500, AppColors.blue700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.blue600.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 12),
        const Text(
          'SMARTSTUDIO',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.gray800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Solusi Penyewaan Kamera & Studio',
          style: TextStyle(fontSize: 12.5, color: AppColors.gray500),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue600.withOpacity(0.12),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Masuk Akun',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selamat datang kembali 👋',
              style: TextStyle(fontSize: 13.5, color: AppColors.gray500),
            ),
            const SizedBox(height: 24),

            // Email
            AppTextField(
              label: 'Email',
              placeholder: 'contoh@email.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AppColors.gray400),
              onChanged: (_) => setState(() => _error = ''),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email wajib diisi';
                if (!v.contains('@')) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Password
            AppTextField(
              label: 'Password',
              placeholder: 'Masukkan password',
              controller: _passCtrl,
              obscure: !_showPass,
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.gray400),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.gray400,
                ),
                onPressed: () => setState(() => _showPass = !_showPass),
              ),
              onChanged: (_) => setState(() => _error = ''),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                return null;
              },
            ),

            // Lupa password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ForgotEmailPage())),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Lupa kata sandi?',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue600,
                  ),
                ),
              ),
            ),

            // Error message
            if (_error.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.red500.withOpacity(0.3)),
                ),
                child: Text(
                  _error,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.red500,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Tombol masuk
            AppButton(
              text: 'Masuk',
              loading: _loading,
              onPressed: _loading ? null : _doLogin,
            ),
            const SizedBox(height: 20),

            // Footer daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Belum punya akun? ',
                  style: TextStyle(fontSize: 13, color: AppColors.gray500),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterPage())),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}