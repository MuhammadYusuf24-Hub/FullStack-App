import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/app_them.dart';
import 'package:flutter_application_1/Service/serviceapi.dart';
import 'login.dart';

class ForgotResetPage extends StatefulWidget {
  final String email;
  final String otp;
  const ForgotResetPage({super.key, required this.email, required this.otp});

  @override
  State<ForgotResetPage> createState() => _ForgotResetPageState();
}

class _ForgotResetPageState extends State<ForgotResetPage>
    with SingleTickerProviderStateMixin {
  final _formKey   = GlobalKey<FormState>();
  final _passCtrl  = TextEditingController();
  final _konfCtrl  = TextEditingController();

  bool _loading  = false;
  bool _showPass = false;
  bool _showKonf = false;
  String _error  = '';

  late AnimationController _anim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _passCtrl.dispose();
    _konfCtrl.dispose();
    super.dispose();
  }

  int _strength(String pw) {
    if (pw.isEmpty) return 0;
    int s = 0;
    if (pw.length >= 6)                          s++;
    if (pw.length >= 10)                         s++;
    if (pw.contains(RegExp(r'[A-Z]')))           s++;
    if (pw.contains(RegExp(r'[0-9]')))           s++;
    if (pw.contains(RegExp(r'[^A-Za-z0-9]')))   s++;
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

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _konfCtrl.text) {
      setState(() => _error = 'Konfirmasi password tidak cocok.');
      return;
    }
    setState(() { _loading = true; _error = ''; });

    final data = await ServiceApi.resetPassword(
        widget.email, widget.otp, _passCtrl.text);

    if (!mounted) return;
    setState(() => _loading = false);

    if (data['status'] == 'success') {
      _showSuccessDialog();
    } else {
      setState(() => _error = data['message'] ?? 'Gagal mereset password.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.green50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.green500,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Password Berhasil Diubah!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan masuk kembali dengan password baru kamu.',
                style: TextStyle(fontSize: 13.5, color: AppColors.gray500, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Login Sekarang',
                gradient: AppColors.btnGradientGreen,
                shadowColor: Color(0x4016A34A),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pw     = _passCtrl.text;
    final konf   = _konfCtrl.text;
    final s      = _strength(pw);
    final match  = konf.isNotEmpty && pw == konf;
    final noMatch = konf.isNotEmpty && pw != konf;

    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.gray700, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Password Baru',
          style: TextStyle(
              color: AppColors.gray800, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Step indicator
                    const StepIndicator(current: 3),
                    const SizedBox(height: 24),

                    // Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.green50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.green600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Buat Password Baru',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gray800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Buat password yang kuat dan mudah kamu ingat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.5, color: AppColors.gray500, height: 1.6),
                    ),
                    const SizedBox(height: 28),

                    // Password baru
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppTextField(
                        label: 'Password Baru',
                        placeholder: 'Minimal 6 karakter',
                        controller: _passCtrl,
                        obscure: !_showPass,
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            size: 18, color: AppColors.gray400),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: AppColors.gray400,
                          ),
                          onPressed: () =>
                              setState(() => _showPass = !_showPass),
                        ),
                        onChanged: (_) => setState(() => _error = ''),
                        validator: (v) {
                          if (v?.isEmpty ?? true) return 'Password wajib diisi';
                          if (v!.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                      ),
                    ),

                    // Strength bar
                    if (pw.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (i) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                              decoration: BoxDecoration(
                                color: i < s
                                    ? _strengthColor(s)
                                    : AppColors.gray200,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
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
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Konfirmasi password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppTextField(
                        label: 'Konfirmasi Password',
                        placeholder: 'Ulangi password baru',
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
                            _showKonf
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: AppColors.gray400,
                          ),
                          onPressed: () =>
                              setState(() => _showKonf = !_showKonf),
                        ),
                        onChanged: (_) => setState(() => _error = ''),
                        validator: (v) =>
                            (v?.isEmpty ?? true)
                                ? 'Konfirmasi wajib diisi'
                                : null,
                      ),
                    ),
                    if (match)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
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
                      ),
                    if (noMatch)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
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
                      ),

                    // Error
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
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
                      text: 'Simpan Password Baru',
                      loading: _loading,
                      gradient: AppColors.btnGradientGreen,
                      shadowColor: const Color(0x4016A34A),
                      onPressed: (_loading || !match) ? null : _reset,
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        '← Kembali',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}