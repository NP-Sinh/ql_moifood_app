import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ql_moifood_app/api/api_urls.dart';
import '../models/category.dart';

class ApiCategory {
  final Logger _logger = Logger();

  Future<List<Category>> getAllCategory() async {
    try {
      final response = await http.get(ApiUrls.categoryGetAll);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        _logger.w(
          "That Bai: ${response.statusCode} - ${response.reasonPhrase}",
        );
        return [];
      }
    } catch (e, st) {
      _logger.e("error", error: e, stackTrace: st);
      return [];
    }
  }
}