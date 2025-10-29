import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/user.dart';

class ApiUser {
  final Logger _logger = Logger();

  // Tạo headers
  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // GET: Lấy tất cả danh mục
  Future<List<User>> getAllUser({required String token}) async {
    try {
      final response = await http.get(
        ApiUrls.getAllUser,
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        _logger.w('Lấy user thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi lấy user', error: e, stackTrace: st);
      return [];
    }
  }

  // GET: lay user by id
  Future<User?> getUserById({required int id, required String token}) async {
    try {
      final uri = ApiUrls.getUserById.replace(
        queryParameters: {'userId': id.toString()},
      );

      final response = await http.get(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        _logger.w('Lấy chi tiết đơn hàng thất bại: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      if (e is TypeError) {
        _logger.e(
          'Lỗi ép kiểu JSON trong getOrderById, kiểm tra API response!',
          error: e,
          stackTrace: st,
        );
      } else {
        _logger.e('Lỗi lấy chi tiết đơn hàng', error: e, stackTrace: st);
      }
      return null;
    }
  }

  // Search user
  Future<List<User>> searchUser({
    required String keyword,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.searchUser.replace(
        queryParameters: {'keyword': keyword},
      );

      final response = await http.get(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        _logger.w('Tìm kiếm user thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi tìm kiếm user', error: e, stackTrace: st);
      return [];
    }
  }

  // Set active user
  Future<User?> setActiveUser({
    required int id,
    required bool isActive,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.setActiveUser.replace(
        queryParameters: {'id': id.toString(), 'isActive': isActive.toString()},
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return User.fromJson(responseBody);
      } else {
        _logger.w('setActiveUser thất bại: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      _logger.e('Lỗi khi gọi setActiveUser', error: e, stackTrace: st);
      return null;
    }
  }
}
