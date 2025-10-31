import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_notification.dart';
import 'package:ql_moifood_app/models/global_notification.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

class NotificationViewModel extends ChangeNotifier {
  final ApiNotifications _api = ApiNotifications();

  // notifications by userId
  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  // Global notifications
  bool _isLoadingGlobal = false;
  bool get isLoadingGlobal => _isLoadingGlobal;
  List<GlobalNotification> _globalNotifications = [];
  List<GlobalNotification> get globalNotifications => _globalNotifications;

  // Sending state
  bool _isSending = false;
  bool get isSending => _isSending;

  // Deleting state
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Get token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn hoặc không hợp lệ.';
      notifyListeners();
      return null;
    }
    _errorMessage = null;
    return token;
  }

  // tải DL thông báo hệ thống
  Future<void> fetchGlobalNotifications() async {
    _isLoadingGlobal = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingGlobal = false;
        notifyListeners();
        return;
      }
      _globalNotifications = await _api.getGlobalNotifications(token: token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _globalNotifications = [];
    } finally {
      _isLoadingGlobal = false;
      notifyListeners();
    }
  }

  // tải DL thông báo cá nhân
  Future<void> fetchNotificationsByUserId(int? userId) async {
    _isLoadingUser = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingUser = false;
        notifyListeners();
        return;
      }
      _userNotifications = await _api.getNotificationsByUserId(
        token: token,
        userId: userId,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _userNotifications = [];
    } finally {
      _isLoadingUser = false;
      notifyListeners();
    }
  }

  Future<bool> sendGlobalNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isSending = false;
        notifyListeners();
        return false;
      }

      final success = await _api.sendGlobalNotification(
        token: token,
        title: title,
        message: message,
        type: type,
      );

      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<bool> sendNotificationToUser({
    required int userId,
    required String title,
    required String message,
    required String type,
  }) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isSending = false;
        notifyListeners();
        return false;
      }

      final success = await _api.sendNotificationToUser(
        token: token,
        userId: userId,
        title: title,
        message: message,
        type: type,
      );

      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isDeleting = false;
        notifyListeners();
        return false;
      }

      final success = await _api.deleteNotification(
        token: token,
        notificationId: notificationId,
      );

      if (success) {
        _userNotifications.removeWhere(
          (n) => n.notificationId == notificationId,
        );
      }

      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
