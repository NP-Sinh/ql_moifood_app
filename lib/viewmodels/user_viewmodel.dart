import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_user.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart'; // Giả định

class UserViewModel extends ChangeNotifier {
  final ApiUser _apiUser = ApiUser();

  bool _isLoading = false;
  String? _errorMessage;
  List<User> _users = [];

  // Getters cho UI
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getters để chia danh sách cho 2 tab (Active và Inactive)
  List<User> get activeUsers => _users.where((user) => user.isActive).toList();
  List<User> get inactiveUsers =>
      _users.where((user) => !user.isActive).toList();

  // --- Helpers ---
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Lấy token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn';
      return null;
    }
    return token;
  }

  /// Lấy hoặc tải lại toàn bộ danh sách người dùng
  Future<void> fetchUsers() async {
    _setLoading(true);
    _setError(null);

    final token = await _getToken();
    if (token == null) {
      _setError("Lỗi xác thực, vui lòng đăng nhập lại.");
      _setLoading(false);
      return;
    }
    try {
      final users = await _apiUser.getAllUser(token: token);
      _users = users;
    } catch (e) {
      _setError("Không thể tải danh sách người dùng: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  /// Tìm kiếm người dùng theo từ khóa
  Future<void> searchUsers(String keyword) async {
    // Nếu keyword rỗng, tải lại toàn bộ danh sách
    if (keyword.trim().isEmpty) {
      await fetchUsers();
      return;
    }

    _setLoading(true);
    _setError(null);

    final token = await _getToken();
    if (token == null) {
      _setError("Lỗi xác thực, vui lòng đăng nhập lại.");
      _setLoading(false);
      return;
    }

    try {
      final users = await _apiUser.searchUser(keyword: keyword, token: token);
      _users = users;
    } catch (e) {
      _setError("Lỗi tìm kiếm: ${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  /// Cập nhật trạng thái Active/Inactive cho người dùng
  Future<bool> setActiveUser({
    required int userId,
    required bool isActive,
  }) async {
    _setError(null);

    final token = await _getToken();
    if (token == null) {
      _setError("Lỗi xác thực.");
      return false;
    }

    try {
      final updatedUser = await _apiUser.setActiveUser(
        id: userId,
        isActive: isActive,
        token: token,
      );

      if (updatedUser != null) {
        final index = _users.indexWhere((user) => user.userId == userId);
        if (index != -1) {
          _users[index] = updatedUser;
          notifyListeners();
        } else {
          await fetchUsers();
        }
        await fetchUsers();
        return true;
      } else {
        _setError("Không thể cập nhật trạng thái người dùng.");
        return false;
      }
    } catch (e) {
      _setError("Lỗi khi cập nhật: ${e.toString()}");
      return false;
    }
  }
}
