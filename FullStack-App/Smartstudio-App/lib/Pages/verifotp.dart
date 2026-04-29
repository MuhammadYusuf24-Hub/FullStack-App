import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Pages/app_them.dart';
import 'package:flutter_application_1/Service/serviceapi.dart';
import 'ubahpass.dart';

class ForgotOtpPage extends StatefulWidget {
  final String email;
  const ForgotOtpPage({super.key, required this.email});

  @override
  State<ForgotOtpPage> createState() => _ForgotOtpPageState();
}

class _ForgotOtpPageState extends State<ForgotOtpPage>
    with SingleTickerProviderStateMixin {
  static const int _otpLength  = 6;
  static const int _countdown  = 5 * 60; // 300 detik

  // Satu controller per box OTP
  final List<TextEditingController> _ctrl =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focus =
      List.generate(_otpLength, (_) => FocusNode());

  int _seconds  = _countdown;
  bool _loading = false;
  bool _resending = false;
  bool _hasError = false;
  String _error = '';
  String _info  = '';
  Timer? _timer;

  late AnimationController _anim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    for (final c in _ctrl) c.dispose();
    for (final f in _focus) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds <= 0) {
        _timer?.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  bool get _isExpired => _seconds <= 0;
  String get _otpValue => _ctrl.map((c) => c.text).join();
  bool get _otpFull   => _otpValue.length == _otpLength;

  void _onChanged(String val, int i) {
    // Hanya terima angka
    if (val.isNotEmpty && !RegExp(r'[0-9]').hasMatch(val)) {
      _ctrl[i].clear();
      return;
    }
    setState(() { _hasError = false; _error = ''; });
    if (val.isNotEmpty && i < _otpLength - 1) {
      _focus[i + 1].requestFocus();
    }
  }

  void _onKeyDown(KeyEvent event, int i) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrl[i].text.isEmpty &&
        i > 0) {
      _focus[i - 1].requestFocus();
    }
  }

  Future<void> _verify() async {
    setState(() { _error = ''; _hasError = false; });
    if (!_otpFull) { setState(() => _error = 'Masukkan 6 digit kode OTP.'); return; }
    if (_isExpired) { setState(() => _error = 'Kode OTP sudah kedaluwarsa. Kirim ulang.'); return; }

    setState(() => _loading = true);
    final data = await ServiceApi.verifikasiOtp(widget.email, _otpValue);
    if (!mounted) return;
    setState(() => _loading = false);

    if (data['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotResetPage(email: widget.email, otp: _otpValue),
        ),
      );
    } else {
      setState(() {
        _hasError = true;
        _error = data['message'] ?? 'Kode OTP tidak valid.';
      });
      // Shake + clear
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      for (final c in _ctrl) c.clear();
      setState(() => _hasError = false);
      _focus[0].requestFocus();
    }
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() { _resending = true; _error = ''; _info = ''; });

    final data = await ServiceApi.kirimOtp(widget.email);
    if (!mounted) return;
    setState(() => _resending = false);

    if (data['status'] == 'success') {
      setState(() {
        _seconds = _countdown;
        _info = 'Kode OTP baru telah dikirim ke email kamu.';
      });
      _startTimer();
      for (final c in _ctrl) c.clear();
      _focus[0].requestFocus();
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _info = '');
      });
    } else {
      setState(() => _error = data['message'] ?? 'Gagal kirim ulang.');
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
          'Verifikasi OTP',
          style: TextStyle(color: AppColors.gray800, fontWeight: FontWeight.w700, fontSize: 16),
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
              child: Column(
                children: [
                  // Step indicator
                  const StepIndicator(current: 2),
                  const SizedBox(height: 24),

                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.blue600,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Masukkan Kode OTP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 13.5, color: AppColors.gray500, height: 1.6),
                      children: [
                        const TextSpan(text: 'Kode 6 digit dikirim ke\n'),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_otpLength, (i) {
                      return Container(
                        width: 46,
                        height: 54,
                        margin: EdgeInsets.only(right: i < _otpLength - 1 ? 8 : 0),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (e) => _onKeyDown(e, i),
                          child: TextField(
                            controller: _ctrl[i],
                            focusNode: _focus[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            onChanged: (v) => _onChanged(v, i),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _ctrl[i].text.isNotEmpty
                                  ? AppColors.blue700
                                  : AppColors.gray800,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '·',
                              hintStyle: const TextStyle(
                                  color: AppColors.gray300, fontSize: 22),
                              filled: true,
                              fillColor: _hasError
                                  ? AppColors.red50
                                  : _ctrl[i].text.isNotEmpty
                                      ? AppColors.blue50
                                      : AppColors.gray50,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _hasError
                                      ? AppColors.red500
                                      : _ctrl[i].text.isNotEmpty
                                          ? AppColors.blue500
                                          : AppColors.gray200,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _hasError
                                      ? AppColors.red500
                                      : AppColors.blue500,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: _isExpired ? AppColors.red500 : AppColors.gray400,
                      ),
                      const SizedBox(width: 5),
                      if (_isExpired)
                        const Text(
                          'Kode kedaluwarsa',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red500,
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 12.5, color: AppColors.gray400),
                            children: [
                              const TextSpan(text: 'Berlaku selama '),
                              TextSpan(
                                text: _fmt(_seconds),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Error / Info
                  if (_error.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.red50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.red500.withOpacity(0.3)),
                      ),
                      child: Text(
                        _error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.red500, fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (_info.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.green50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.green500.withOpacity(0.3)),
                      ),
                      child: Text(
                        _info,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.green600, fontWeight: FontWeight.w600),
                      ),
                    ),

                  AppButton(
                    text: 'Verifikasi Kode',
                    loading: _loading,
                    onPressed: (_loading || !_otpFull || _isExpired) ? null : _verify,
                  ),
                  const SizedBox(height: 16),

                  // Resend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Tidak menerima kode? ',
                        style: TextStyle(fontSize: 13, color: AppColors.gray500),
                      ),
                      GestureDetector(
                        onTap: _resending ? null : _resend,
                        child: Text(
                          _resending ? 'Mengirim...' : 'Kirim ulang',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _resending ? AppColors.gray400 : AppColors.blue600,
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
    );
  }
}