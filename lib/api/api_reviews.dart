import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/review.dart';

class ApiReviews {
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

  // GET: Lấy tất cả reviews
  Future<List<Review>> getAllReviews({required String token}) async {
    try {
      final response = await http.get(
        ApiUrls.getAllReviews,
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        _logger.w('Lấy review thất bại: ${response.statusCode}');
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi lấy review', error: e, stackTrace: st);
      return [];
    }
  }

  // xóa review
  Future<bool> deleteReview({
    required int reviewId,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.deleteByAdmin.replace(
        queryParameters: {'reviewId': reviewId.toString()},
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        _logger.i('delete review (reviewId: $reviewId) thành công');
        return true;
      } else {
        _logger.w('delete review thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi delete review', error: e, stackTrace: st);
      return false;
    }
  }

  // lọc review
  Future<List<Review>> filterReviews({
    required String token,
    String? foodName,
    String? fullName,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'foodName': foodName?.toString(),
        'fullName': fullName?.toString(),
        'minRating': minRating?.toString(),
        'maxRating': maxRating?.toString(),
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
      };
      queryParameters.removeWhere((key, value) => value == null);

      final uri = ApiUrls.filterReviews.replace(
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );

      final response = await http.get(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        _logger.w(
          'Lọc review thất bại: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e, st) {
      _logger.e('Lỗi lọc review', error: e, stackTrace: st);
      return [];
    }
  }
}
