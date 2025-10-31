import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ql_moifood_app/api/api_urls.dart';
import 'package:ql_moifood_app/models/notification.dart';

class ApiNotifications {

  /// Lấy danh sách thông báo của user (cả personal + global)
  Future<List<NotificationModel>> getUserNotifications({
    required String token,
    bool? isRead,
  }) async {
    try {
      final url = isRead != null
          ? Uri.parse('${ApiUrls.getUserNotifications}?isRead=$isRead')
          : ApiUrls.getUserNotifications;

      final response = await http.get(
        url,
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

  /// Đánh dấu một thông báo là đã đọc
  /// POST /moifood/notification/mark-as-read?notificationId={id}
  Future<bool> markAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiUrls.markAsRead}?notificationId=$notificationId',
      );

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
          'Lỗi đánh dấu đã đọc: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Đánh dấu tất cả thông báo là đã đọc
  /// POST /moifood/notification/mark-all-as-read
  Future<bool> markAllAsRead({required String token}) async {
    try {
      final response = await http.post(
        ApiUrls.markAllAsRead,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Lỗi đánh dấu tất cả đã đọc: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ADMIN 

  /// Lấy tất cả thông báo 
  /// GET /moifood/notification
  Future<List<NotificationModel>> getAllNotifications({
    required String token,
  }) async {
    try {
      final response = await http.get(
        ApiUrls.getUserNotifications,
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
  /// POST /moifood/notification/admin/send-to-all
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
  /// POST /moifood/notification/admin/send-to-user
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
  /// POST /moifood/notification/admin/delete?id={id}
  Future<bool> deleteNotification({
    required String token,
    required int notificationId,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiUrls.deleteNotification}?id=$notificationId',
      );

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