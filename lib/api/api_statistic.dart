import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';

class ApiStatistic {
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

  // Tạo Uri với query parameters
  Uri _buildUriWithParams(Uri baseUri, Map<String, dynamic> params) {
    final queryParameters = <String, String>{};
    params.forEach((key, value) {
      if (value != null) {
        if (value is DateTime) {
          // Định dạng DateTime thành YYYY-MM-DD (hoặc định dạng API yêu cầu)
          // Đảm bảo API C# của bạn có thể parse định dạng này
          queryParameters[key] = value.toIso8601String().split('T').first;
        } else {
          queryParameters[key] = value.toString();
        }
      }
    });
    // Remove null values before creating the URI
    queryParameters.removeWhere((key, value) => value == 'null');
    return baseUri.replace(queryParameters: queryParameters);
  }

  // thống kê doanh thu theo này, tuần, tháng, năm
  Future<dynamic> getRevenue({
    required String token,
    DateTime? fromDate,
    DateTime? toDate,
    required String groupBy, // 'day', 'week', 'month', 'year'
  }) async {
    final uri = _buildUriWithParams(ApiUrls.getRevenue, {
      'fromDate': fromDate,
      'toDate': toDate,
      'groupBy': groupBy,
    });
    _logger.i("Calling GET: $uri");

    try {
      final response = await http.get(uri, headers: _getHeaders(token: token));
      _logger.d("Response Status: ${response.statusCode}");
      _logger.d("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _logger.w(
          'Lỗi lấy doanh thu: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Lỗi lấy doanh thu: ${response.statusCode}');
      }
    } catch (e, st) {
      _logger.e('Lỗi API getRevenue', error: e, stackTrace: st);
      throw Exception('Lỗi kết nối hoặc xử lý dữ liệu doanh thu.');
    }
  }

  // Thống kê số lượng đơn hàng theo ngày, tuần, tháng, năm
  Future<dynamic> getOrderCount({
    required String token,
    DateTime? fromDate,
    DateTime? toDate,
    required String groupBy,
  }) async {
    final uri = _buildUriWithParams(ApiUrls.getOrderCount, {
      'fromDate': fromDate,
      'toDate': toDate,
      'groupBy': groupBy,
    });
    _logger.i("Calling GET: $uri");

    try {
      final response = await http.get(uri, headers: _getHeaders(token: token));
      _logger.d("Response Status: ${response.statusCode}");
      _logger.d("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _logger.w(
          'Lỗi lấy số lượng đơn hàng: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Lỗi lấy số lượng đơn hàng: ${response.statusCode}');
      }
    } catch (e, st) {
      _logger.e('Lỗi API getOrderCount', error: e, stackTrace: st);
      throw Exception('Lỗi kết nối hoặc xử lý dữ liệu số lượng đơn hàng.');
    }
  }

  // Thống kê món ăn được đặt nhiều nhất, ít nhất
  Future<dynamic> getFoodOrderStats({
    required String token,
    required int top,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final uri = _buildUriWithParams(ApiUrls.getFoodOrderStats, {
      'top': top,
      'fromDate': fromDate,
      'toDate': toDate,
    });
    _logger.i("Calling GET: $uri");

    try {
      final response = await http.get(uri, headers: _getHeaders(token: token));
      _logger.d("Response Status: ${response.statusCode}");
      _logger.d("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _logger.w(
          'Lỗi lấy thống kê món ăn: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Lỗi lấy thống kê món ăn: ${response.statusCode}');
      }
    } catch (e, st) {
      _logger.e('Lỗi API getFoodOrderStats', error: e, stackTrace: st);
      throw Exception('Lỗi kết nối hoặc xử lý dữ liệu thống kê món ăn.');
    }
  }
}
