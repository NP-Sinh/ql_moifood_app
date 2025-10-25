import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ql_moifood_app/models/auth/login.dart';
import 'api_urls.dart';
import 'package:logger/logger.dart';

class AuthApi {
  final Logger _logger = Logger();

  // Đăng nhập
  Future<Login?> login(String usernameOrEmail, String password) async {
    try {
      final response = await http.post(
        ApiUrls.login,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usernameOrEmail': usernameOrEmail,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return Login.fromJson(jsonDecode(response.body));
      } else {
        _logger.w(
          "Login failed: ${response.statusCode} - ${response.reasonPhrase}",
        );
        return null;
      }
    } catch (e, st) {
      _logger.e("Login error", error: e, stackTrace: st);
      return null;
    }
  }
}
