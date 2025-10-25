import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import '../models/category.dart';

class ApiCategory {
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
  Future<List<Category>> getAllCategory() async {
    try {
      final response = await http.get(ApiUrls.getAllCategory);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        _logger.w('Lấy danh mục thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi lấy danh mục', error: e, stackTrace: st);
      return [];
    }
  }

  // POST: Thêm/Sửa danh mục
  Future<bool> modify({
    required int id,
    required String name,
    required String description,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.modifyCategory.replace(
        queryParameters: {'id': id.toString()},
      );

      final response = await http.post(
        uri,
        headers: _getHeaders(token: token),
        body: json.encode({'name': name, 'description': description}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('${id == 0 ? "Thêm" : "Sửa"} danh mục thành công');
        return true;
      } else {
        _logger.w('Modify thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi modify danh mục', error: e, stackTrace: st);
      return false;
    }
  }

  // POST: Xóa danh mục
  Future<bool> deleteCategory({required int id, required String token}) async {
    try {
      final uri = ApiUrls.deleteCategory.replace(
        queryParameters: {'id': id.toString()},
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        _logger.i('Xóa danh mục thành công');
        return true;
      } else {
        _logger.w('Xóa thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi xóa danh mục', error: e, stackTrace: st);
      return false;
    }
  }
}
