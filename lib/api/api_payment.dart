import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/payment_method.dart';

class ApiPayment {
  final Logger _logger = Logger();

  // tạo headers
  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // lấy tất cả payment method
  Future<List<PaymentMethod>> getAllPaymentMethod({
    required String token,
  }) async {
    try {
      final response = await http.get(
        ApiUrls.getAllPaymentMethods,
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        _logger.w('thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi', error: e, stackTrace: st);
      return [];
    }
  }

  // lấy payment method id
  Future<PaymentMethod?> getPaymentMethodById({
    required int methodId,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.getPaymentMethodById.replace(
        queryParameters: {'methodId': methodId.toString()},
      );
      final response = await http.get(uri, headers: _getHeaders(token: token));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PaymentMethod.fromJson(data);
      } else {
        _logger.w('thất bại: ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      if (e is TypeError) {
        _logger.e(
          'Lỗi ép kiểu JSON, kiểm tra API response!',
          error: e,
          stackTrace: st,
        );
      } else {
        _logger.e('Lỗi lấy chi tiết đơn hàng', error: e, stackTrace: st);
      }
      return null;
    }
  }

  // Modify (Thêm/Sửa)
  Future<bool> modifyPaymentMethod({
    required int id,
    required String name,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.modifyPaymentMethods.replace(
        queryParameters: {'id': id.toString()},
      );
      final response = await http.post(
        uri,
        headers: _getHeaders(token: token),
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('${id == 0 ? "Thêm" : "Sửa"} thành công');
        return true;
      } else {
        _logger.w('Modify thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi modify', error: e, stackTrace: st);
      return false;
    }
  }

  //delete
  Future<bool> deletePaymentMethod({
    required int id,
    required String token,
  }) async {
    try {
      final url = Uri.parse('${ApiUrls.deletePaymentMethod}?id=$id');

      final response = await http.post(url, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Lỗi xóa: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
