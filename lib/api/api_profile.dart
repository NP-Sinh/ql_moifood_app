import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:logger/logger.dart';

class ProfileApi {
  final Logger _logger = Logger();

  Future<User?> getProfile(String token) async {
    try {
      final response = await http.get(
        ApiUrls.getProfile,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Kiểm tra JSON thực tế của API
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data')) {
            // Nếu API trả về { "data": { user... } }
            return User.fromJson(data['data']);
          }
          return User.fromJson(data);
        }
      } else {
        _logger.w("Get profile failed: ${response.statusCode}");
      }
    } catch (e, st) {
      _logger.e("Get profile error", error: e, stackTrace: st);
    }
    return null;
  }
}
