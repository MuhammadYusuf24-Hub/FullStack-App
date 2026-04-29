import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/app_them.dart';
import 'package:flutter_application_1/Service/serviceapi.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _hpCtrl    = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _konfCtrl  = TextEditingController();

  bool _loading       = false;
  bool _showPass      = false;
  bool _showKonf      = false;
  String _error       = '';

  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _namaCtrl.dispose(); _emailCtrl.dispose(); _hpCtrl.dispose();
    _passCtrl.dispose(); _konfCtrl.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _konfCtrl.text) {
      setState(() => _error = 'Konfirmasi password tidak cocok.');
      return;
    }

    setState(() { _loading = true; _error = ''; });

    final data = await ServiceApi.register({
      'username': _namaCtrl.text.trim(),
      'email'   : _emailCtrl.text.trim(),
      'no_hp'   : _hpCtrl.text.trim(),
      'password': _passCtrl.text,
    });

    if (!mounted) return;
    setState(() => _loading = false);

    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Daftar berhasil! Silakan masuk.'),
        backgroundColor: AppColors.green600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      Navigator.pop(context);
    } else {
      setState(() => _error = data['message'] ?? 'Registrasi gagal. Coba lagi.');
    }
  }

  /// Kekuatan password (0-5)
  int _strength(String pw) {
    if (pw.isEmpty) return 0;
    int s = 0;
    if (pw.length >= 6)             s++;
    if (pw.length >= 10)            s++;
    if (pw.contains(RegExp(r'[A-Z]'))) s++;
    if (pw.contains(RegExp(r'[0-9]'))) s++;
    if (pw.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  Color _strengthColor(int s) {
    if (s <= 1) return AppColors.red500;
    if (s <= 3) return AppColors.amber500;
    return AppColors.green500;
  }

  String _strengthLabel(int s) {
    if (s <= 1) return 'Lemah';
    if (s <= 3) return 'Sedang';
    return 'Kuat';
  }

  @override
  Widget build(BuildContext context) {
    final pw      = _passCtrl.text;
    final konf    = _konfCtrl.text;
    final s       = _strength(pw);
    final match   = konf.isNotEmpty && pw == konf;
    final noMatch = konf.isNotEmpty && pw != konf;

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.gray700, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buat Akun Baru',
          style: TextStyle(
            color: AppColors.gray800,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Card ──────────────────────────────────────
                  Container(
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
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon header
                        Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.blue50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: AppColors.blue600,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gray800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Buat akun baru 🚀',
                            style: TextStyle(fontSize: 13.5, color: AppColors.gray500),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Fields ──
                        AppTextField(
                          label: 'Nama Lengkap',
                          placeholder: 'Nama lengkap kamu',
                          controller: _namaCtrl,
                          prefixIcon: const Icon(Icons.person_outline_rounded,
                              size: 18, color: AppColors.gray400),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),

                        AppTextField(
                          label: 'Email',
                          placeholder: 'contoh@email.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined,
                              size: 18, color: AppColors.gray400),
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Email wajib diisi';
                            if (!v!.contains('@')) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        AppTextField(
                          label: 'Nomor HP',
                          placeholder: '08xxxxxxxxxxxx',
                          controller: _hpCtrl,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_outlined,
                              size: 18, color: AppColors.gray400),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Nomor HP wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),

                        // Password + strength bar
                        AppTextField(
                          label: 'Password',
                          placeholder: 'Minimal 6 karakter',
                          controller: _passCtrl,
                          obscure: !_showPass,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              size: 18, color: AppColors.gray400),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 18, color: AppColors.gray400,
                            ),
                            onPressed: () => setState(() => _showPass = !_showPass),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Password wajib diisi';
                            if (v!.length < 6) return 'Password minimal 6 karakter';
                            return null;
                          },
                        ),
                        if (pw.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          // Strength bar
                          Row(
                            children: List.generate(5, (i) {
                              return Expanded(
                                child: Container(
                                  height: 4,
                                  margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                                  decoration: BoxDecoration(
                                    color: i < s ? _strengthColor(s) : AppColors.gray200,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: _strengthColor(s).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              _strengthLabel(s),
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: _strengthColor(s),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // Konfirmasi password
                        AppTextField(
                          label: 'Konfirmasi Password',
                          placeholder: 'Ulangi password',
                          controller: _konfCtrl,
                          obscure: !_showKonf,
                          prefixIcon: Icon(
                            Icons.shield_outlined,
                            size: 18,
                            color: match
                                ? AppColors.green500
                                : noMatch
                                    ? AppColors.red500
                                    : AppColors.gray400,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showKonf ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 18, color: AppColors.gray400,
                            ),
                            onPressed: () => setState(() => _showKonf = !_showKonf),
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Konfirmasi password wajib diisi' : null,
                        ),
                        if (match)
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              '✓ Password cocok',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green500,
                              ),
                            ),
                          ),
                        if (noMatch)
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              '✗ Password tidak cocok',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red500,
                              ),
                            ),
                          ),

                        // Error
                        if (_error.isNotEmpty) ...[
                          const SizedBox(height: 14),
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
                        ],

                        const SizedBox(height: 22),
                        AppButton(
                          text: 'Daftar Sekarang',
                          loading: _loading,
                          onPressed: _loading ? null : _doRegister,
                        ),
                        const SizedBox(height: 20),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun? ',
                              style: TextStyle(fontSize: 13, color: AppColors.gray500),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Masuk',
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}