import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/global_notification.dart';
import 'package:ql_moifood_app/models/notification.dart';

class ApiNotifications {
  // lấy tất cả thông báo hệ thống
  Future<List<GlobalNotification>> getGlobalNotifications({
    required String token,
  }) async {
    try {
      final response = await http.get(
        ApiUrls.getGlobalNotifications,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GlobalNotification.fromJson(json)).toList();
      } else {
        throw Exception(
          'Lỗi tải thông báo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Lấy thông báo của từng user (nếu userId = null thì lấy tất cả)
  Future<List<NotificationModel>> getNotificationsByUserId({
    required String token,
    int? userId,
  }) async {
    try {
      // ✅ Tạo URL đầy đủ, thêm query nếu có userId
      final uri = userId != null
          ? Uri.parse('${ApiUrls.getNotificationsByUserId}?userId=$userId')
          : ApiUrls.getNotificationsByUserId;

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Lỗi tải thông báo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Gửi thông báo toàn hệ thống
  Future<bool> sendGlobalNotification({
    required String token,
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      final body = json.encode({
        'title': title,
        'message': message,
        'type': type,
      });

      final response = await http.post(
        ApiUrls.sendGlobalNotification,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Lỗi gửi thông báo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Gửi thông báo cho một người dùng cụ thể
  Future<bool> sendNotificationToUser({
    required String token,
    required int userId,
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      final body = json.encode({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
      });

      final response = await http.post(
        ApiUrls.sendNotificationToUser,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Lỗi gửi thông báo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Xóa thông báo
  Future<bool> deleteNotification({
    required String token,
    required int notificationId,
  }) async {
    try {
      final url = Uri.parse('${ApiUrls.deleteNotification}?id=$notificationId');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Lỗi xóa thông báo: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
