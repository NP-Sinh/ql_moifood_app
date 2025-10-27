import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import '../models/food.dart';

class FoodApi {
  final Logger _logger = Logger();

  // Tạo headers
  Map<String, String> _getHeaders({String? token, bool isMultipart = false}) {
    final headers = {
      if (!isMultipart)
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-R',
    };
    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // lấy danh sách món ăn
  Future<List<Food>> getAllFood({bool? isAvailable, bool? isActive}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        if (isAvailable != null) 'isAvailable': isAvailable.toString(),
        if (isActive != null) 'isActive': isActive.toString(),
      };

      final uri = ApiUrls.foodGetAll.replace(queryParameters: queryParameters);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Food.fromJson(json)).toList();
      } else {
        _logger.w(
          "Lấy món ăn thất bại: ${response.statusCode} - ${response.reasonPhrase}",
        );
        return [];
      }
    } catch (e, st) {
      _logger.e("Lỗi lấy món ăn", error: e, stackTrace: st);
      return [];
    }
  }

  // POST: Thêm mới / Cập nhật món ăn
  Future<bool> modifyFood({
    required int id,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    XFile? imageFile,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.foodModify.replace(
        queryParameters: {'id': id.toString()},
      );
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_getHeaders(token: token, isMultipart: true));

      // Thêm các trường
      request.fields['Name'] = name;
      request.fields['Description'] = description;
      request.fields['Price'] = price.toString();
      request.fields['CategoryId'] = categoryId.toString();
      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'ImageUrl',
            imageFile.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        _logger.i('Modify món ăn (ID: $id) thành công');
        return true;
      } else {
        _logger.w(
          'Modify món ăn thất bại: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi modify món ăn', error: e, stackTrace: st);
      return false;
    }
  }

  // POST: Xóa mềm (true) / Khôi phục (false) món ăn
  Future<bool> setActiveStatus({
    required int id,
    required bool isActive,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.setActiveStatus.replace(
        queryParameters: {'id': id.toString(), 'isActive': isActive.toString()},
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        _logger.i('setActiveStatus (ID: $id, isActive: $isActive) thành công');
        return true;
      } else {
        _logger.w('setActiveStatus thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi setActiveStatus', error: e, stackTrace: st);
      return false;
    }
  }

  // POST: Set Tình trạng (Đang bán / Hết hàng)
  Future<bool> setAvailableStatus({
    required int id,
    required bool isAvailable,
    required String token,
  }) async {
    try {
      final uri = ApiUrls.setAvailableStatus.replace(
        queryParameters: {
          'id': id.toString(),
          'isAvailable': isAvailable.toString(),
        },
      );

      final response = await http.post(uri, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        _logger.i(
          'setAvailableStatus (ID: $id, isAvailable: $isAvailable) thành công',
        );
        return true;
      } else {
        _logger.w('setAvailableStatus thất bại: ${response.statusCode}');
        return false;
      }
    } catch (e, st) {
      _logger.e('Lỗi setAvailableStatus', error: e, stackTrace: st);
      return false;
    }
  }
}
