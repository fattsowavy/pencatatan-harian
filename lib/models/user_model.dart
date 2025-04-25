import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? name;
  String? email;
  String? hashedPassword;

  UserModel({this.name, this.email, this.hashedPassword});

  // Fungsi untuk hashing kata sandi menggunakan SHA-256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Validasi input registrasi
  String? validateRegistration(String name, String email, String password) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Semua kolom harus diisi.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Masukkan email yang valid.';
    }
    if (password.length < 6) {
      return 'Kata sandi harus minimal 6 karakter.';
    }
    return null;
  }

  // Validasi input login
  String? validateLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Email dan kata sandi tidak boleh kosong.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Masukkan email yang valid.';
    }
    return null;
  }

  // Simpan data pengguna ke SharedPreferences
  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String hashedPassword = _hashPassword(password);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    this.name = name;
    this.email = email;
    this.hashedPassword = hashedPassword;
    return true;
  }

  // Verifikasi login
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (storedEmail == null || storedPassword == null) {
      return false; // Akun belum terdaftar
    }

    String hashedPassword = _hashPassword(password);
    if (storedEmail == email && storedPassword == hashedPassword) {
      this.email = email;
      this.hashedPassword = hashedPassword;
      this.name = prefs.getString('name');
      return true;
    }
    return false;
  }
}
