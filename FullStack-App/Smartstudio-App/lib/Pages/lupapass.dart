import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/app_them.dart';
import 'package:flutter_application_1/Service/serviceapi.dart';
import 'verifotp.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({super.key});

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage>
    with SingleTickerProviderStateMixin {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _loading = false;
  String _error = '';

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
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _kirimOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = ''; });

    final data = await ServiceApi.kirimOtp(_emailCtrl.text.trim());

    if (!mounted) return;
    setState(() => _loading = false);

    if (data['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotOtpPage(email: _emailCtrl.text.trim()),
        ),
      );
    } else {
      setState(() => _error = data['message'] ?? 'Email tidak ditemukan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.gray700, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lupa Kata Sandi',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator
                      const Center(child: StepIndicator(current: 1)),
                      const SizedBox(height: 24),

                      // Icon
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.blue50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.blue600,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gray800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'Masukkan email terdaftar. Kami akan\nmengirim kode OTP yang berlaku 5 menit.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.gray500,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Email field
                      AppTextField(
                        label: 'Alamat Email',
                        placeholder: 'contoh@email.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined,
                            size: 18, color: AppColors.gray400),
                        onChanged: (_) => setState(() => _error = ''),
                        validator: (v) {
                          if (v?.isEmpty ?? true) return 'Email wajib diisi';
                          if (!v!.contains('@')) return 'Format email tidak valid';
                          return null;
                        },
                      ),

                      // Error
                      if (_error.isNotEmpty) ...[
                        const SizedBox(height: 10),
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
                        text: 'Kirim Kode OTP',
                        loading: _loading,
                        onPressed: _loading ? null : _kirimOtp,
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Ingat kata sandi? ',
                            style: TextStyle(fontSize: 13, color: AppColors.gray500),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              '← Kembali Masuk',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}