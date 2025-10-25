import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../resources/utils/fetch_data_exception.dart';
import 'api_urls.dart';

class ApiServices {
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        ApiUrls().API_GET_USER,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        throw FetchDataException(
          "StatusCode: ${response.statusCode}, Error: ${response.reasonPhrase}",
        );
      }

      final decoded = json.decode(response.body);
      final usersJson = (decoded['results'] as List<dynamic>)
          .map((json) => User.fromJson(json))
          .toList();

      return usersJson;
    } catch (e) {
      throw FetchDataException("Thất bại: $e");
    }
  }
}
