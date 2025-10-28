import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/order.dart';

class ApiOrder {
  final Logger _logger = Logger();

  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // GET: Lấy tất cả đơn hàng
  Future<List<Order>> getAllOrder({
    String? status,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        if (status != null && status.isNotEmpty) 'status': status,
      };
      final uri = ApiUrls.getAllOrder.replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) {
          final Map<String, dynamic> jsonMap = jsonItem as Map<String, dynamic>;
          jsonMap['orderId'] ??= 0;
          jsonMap['userId'] ??= 0;
          jsonMap['totalAmount'] ??= 0.0;
          jsonMap['orderItems'] ??= [];
          jsonMap['payments'] ??= [];
          return Order.fromJson(jsonMap);
        }).toList();
      } else {
        _logger.w('Lấy danh sách đơn hàng thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi lấy danh sách đơn hàng', error: e, stackTrace: st);
      return [];
    }
  }

  // GET: Lấy chi tiết đơn hàng
  Future<Order?> getOrderById({
    required int orderId,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.getOrderById.replace(
        queryParameters: {'orderId': orderId.toString()},
      );

      final response = await http.get(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final Map<String, dynamic> jsonMap =
              data.first as Map<String, dynamic>;
          jsonMap['orderId'] ??= 0;
          jsonMap['userId'] ??= 0;
          jsonMap['totalAmount'] ??= 0.0;
          jsonMap['orderItems'] ??= [];
          jsonMap['payments'] ??= [];
          return Order.fromJson(jsonMap);
        } else {
          _logger.w('Không tìm thấy đơn hàng với ID: $orderId');
          return null;
        }
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

  // POST: cập nhật trạng thái đơn hàng
  Future<bool> updateOrderStatus({
    required int orderId,
    required String newStatus,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.updateOrderStatus.replace(
        queryParameters: {
          'orderId': orderId.toString(),
          'newStatus': newStatus,
        },
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        _logger.i(
          'Cập nhật trạng thái đơn hàng $orderId thành $newStatus thành công',
        );
        return true;
      } else {
        _logger.w('Cập nhật trạng thái thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi cập nhật trạng thái đơn hàng', error: e, stackTrace: st);
      return false;
    }
  }
}
