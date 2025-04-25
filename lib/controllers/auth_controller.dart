import 'package:flutter/material.dart';
import 'package:penghitung_harian/models/user_model.dart';

class AuthController extends ChangeNotifier {
  final UserModel _userModel = UserModel();
  String errorMessage = '';

  // Getter untuk error message
  String get getErrorMessage => errorMessage;

  // Fungsi untuk registrasi
  Future<bool> register(String name, String email, String password) async {
    String? validationError =
        _userModel.validateRegistration(name, email, password);
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return false;
    }

    bool success = await _userModel.register(name, email, password);
    if (success) {
      errorMessage = '';
      notifyListeners();
      return true;
    }
    errorMessage = 'Registrasi gagal. Silakan coba lagi.';
    notifyListeners();
    return false;
  }

  // Fungsi untuk login
  Future<bool> login(String email, String password) async {
    String? validationError = _userModel.validateLogin(email, password);
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return false;
    }

    bool success = await _userModel.login(email, password);
    if (success) {
      errorMessage = '';
      notifyListeners();
      return true;
    }
    errorMessage = 'Email atau kata sandi salah.';
    notifyListeners();
    return false;
  }
}
