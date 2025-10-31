import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_notification.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

class NotificationViewModel extends ChangeNotifier {
  final ApiNotifications _api = ApiNotifications();

  // User notifications
  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  // Admin - All notifications
  bool _isLoadingAll = false;
  bool get isLoadingAll => _isLoadingAll;
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> get allNotifications => _allNotifications;

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

  // ==================== USER ====================
  Future<void> fetchUserNotifications({bool? isRead}) async {
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
      _userNotifications = await _api.getUserNotifications(
        token: token,
        isRead: isRead,
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

  Future<bool> markAsRead(int notificationId) async {
    _errorMessage = null;
    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.markAsRead(
        token: token,
        notificationId: notificationId,
      );

      if (success) {
        // Update local state
        final index = _userNotifications.indexWhere(
          (n) => n.notificationId == notificationId,
        );
        if (index != -1) {
          _userNotifications[index].isRead = true;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    _errorMessage = null;
    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.markAllAsRead(token: token);

      if (success) {
        // Update local state
        for (var notification in _userNotifications) {
          notification.isRead = true;
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== ADMIN ====================
  Future<void> fetchAllNotifications() async {
    _isLoadingAll = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingAll = false;
        notifyListeners();
        return;
      }
      _allNotifications = await _api.getAllNotifications(token: token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _allNotifications = [];
    } finally {
      _isLoadingAll = false;
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
        _allNotifications.removeWhere(
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