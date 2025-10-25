import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyToken = 'auth_token';
  static const _keyTokenExpiry = 'auth_token_expiry';
  static const _keyRole = 'auth_role';

  static String? _cachedToken;
  static String? _cachedRole;

  // Lưu token và thời gian hết hạn
  static Future<void> saveLogin(
    String token, {
    required String role,
    Duration expiry = const Duration(hours: 24),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(expiry);
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyTokenExpiry, expiryTime.toIso8601String());
    await prefs.setString(_keyRole, role);
    _cachedToken = token;
    _cachedRole = role;
  }

  static Future<String?> getRole() async {
    if (_cachedRole != null) return _cachedRole;
    final prefs = await SharedPreferences.getInstance();
    _cachedRole = prefs.getString(_keyRole);
    return _cachedRole;
  }

  // Lấy token, null nếu hết hạn
  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final expiryStr = prefs.getString(_keyTokenExpiry);
    if (token == null || expiryStr == null) return null;

    final expiry = DateTime.parse(expiryStr);
    if (DateTime.now().isAfter(expiry)) {
      await logout();
      return null;
    }

    _cachedToken = token;
    return token;
  }

  // Xóa token khi logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyTokenExpiry);
    await prefs.remove(_keyRole);
    _cachedToken = null;
    _cachedRole = null;
  }

  // Kiểm tra đăng nhập
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
