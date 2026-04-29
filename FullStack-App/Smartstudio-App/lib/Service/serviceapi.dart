import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceApi {
  static String baseUrl = kIsWeb
      ? "http://127.0.0.1:8000/api/"
      : "http://192.168.1.16:8000/api/";

  static Future login(String email, String password) async {
    var res = await http.post(
      Uri.parse("${baseUrl}login"),
      body: {"email": email, "password": password},
    );
    return jsonDecode(res.body);
  }

  static Future register(Map data) async {
    var res = await http.post(
      Uri.parse("${baseUrl}register.php"),
      body: Map<String, String>.from(data),
    );
    return jsonDecode(res.body);
  }

  static Future getKamera() async {
    var res = await http.get(Uri.parse("${baseUrl}daftarsewa.php"));
    return jsonDecode(res.body);
  }

  static Future getHistory() async {
    var res = await http.get(Uri.parse("${baseUrl}history.php"));
    return jsonDecode(res.body);
  }

  static Future kirimOtp(String email) async {
    try {
      var res = await http
          .post(Uri.parse("${baseUrl}lupapass.php"), body: {"email": email})
          .timeout(Duration(seconds: 30));
      return jsonDecode(res.body);
    } catch (e) {
      return {"status": "error", "message": "Koneksi gagal"};
    }
  }

  static Future verifikasiOtp(String email, String otp) async {
    try {
      var res = await http
          .post(
            Uri.parse("${baseUrl}verifotp.php"),
            body: {"email": email, "otp": otp},
          )
          .timeout(Duration(seconds: 15));
      return jsonDecode(res.body);
    } catch (e) {
      return {"status": "error", "message": "Koneksi gagal"};
    }
  }

  static Future resetPassword(String email, String otp, String password) async {
    var res = await http.post(
      Uri.parse("${baseUrl}ubahpass.php"),
      body: {"email": email, "otp": otp, "password": password},
    );
    return jsonDecode(res.body);
  }
}
