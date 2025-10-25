import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/auth/login.dart';
import '../api/api_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthApi _api = AuthApi();
  String? errorMessage;

  // Đăng nhập
  Future<Login?> login(String usernameOrEmail, String password) async {
    try {
      final result = await _api.login(usernameOrEmail, password);
      if (result == null) {
        errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra thông tin.';
      }
      return result;
    } catch (e) {
      errorMessage = 'Lỗi kết nối. Vui lòng thử lại.';
      return null;
    }
  }
}
