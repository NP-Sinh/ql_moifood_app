import 'package:ql_moifood_app/models/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyToken = 'auth_token';
  static const _keyTokenExpiry = 'auth_token_expiry';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyRefreshTokenExpiry = 'auth_refresh_token_expiry';
  static const _keyRole = 'auth_role';

  static String? _cachedToken;
  static String? _cachedRefreshToken;
  static String? _cachedRole;

  // Callback khi token hết hạn
  static Function()? onTokenExpired;

  // Save login data
  static Future<void> saveLoginData(Login loginData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, loginData.token);
    await prefs.setString(
      _keyTokenExpiry,
      loginData.expiry?.toIso8601String() ?? '',
    );
    await prefs.setString(_keyRefreshToken, loginData.refreshToken);
    await prefs.setString(
      _keyRefreshTokenExpiry,
      loginData.refreshExpiry?.toIso8601String() ?? '',
    );
    await prefs.setString(_keyRole, loginData.role);

    _cachedToken = loginData.token;
    _cachedRefreshToken = loginData.refreshToken;
    _cachedRole = loginData.role;
  }

  // Lấy Access Token với auto logout khi hết hạn
  static Future<String?> getToken() async {
    if (_cachedToken != null) {
      // Kiểm tra cache có còn hợp lệ không
      final prefs = await SharedPreferences.getInstance();
      final expiryStr = prefs.getString(_keyTokenExpiry);
      if (expiryStr != null && expiryStr.isNotEmpty) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          await _handleTokenExpired();
          return null;
        }
      }
      return _cachedToken;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    final expiryStr = prefs.getString(_keyTokenExpiry);

    if (token == null || expiryStr == null || expiryStr.isEmpty) {
      return null;
    }

    final expiry = DateTime.parse(expiryStr);

    if (DateTime.now().isAfter(expiry)) {
      await _handleTokenExpired();
      return null;
    }

    _cachedToken = token;
    return token;
  }

  // Lấy Refresh Token với auto logout khi hết hạn
  static Future<String?> getRefreshToken() async {
    if (_cachedRefreshToken != null) {
      // Kiểm tra cache có còn hợp lệ không
      final prefs = await SharedPreferences.getInstance();
      final expiryStr = prefs.getString(_keyRefreshTokenExpiry);
      if (expiryStr != null && expiryStr.isNotEmpty) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          await _handleTokenExpired();
          return null;
        }
      }
      return _cachedRefreshToken;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyRefreshToken);
    final expiryStr = prefs.getString(_keyRefreshTokenExpiry);

    if (token == null || expiryStr == null || expiryStr.isEmpty) {
      return null;
    }

    final expiry = DateTime.parse(expiryStr);

    if (DateTime.now().isAfter(expiry)) {
      await _handleTokenExpired();
      return null;
    }

    _cachedRefreshToken = token;
    return token;
  }

  // Lấy Role
  static Future<String?> getRole() async {
    if (_cachedRole != null) return _cachedRole;
    final prefs = await SharedPreferences.getInstance();
    _cachedRole = prefs.getString(_keyRole);
    return _cachedRole;
  }

  // Logout và xóa tất cả
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyTokenExpiry);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyRefreshTokenExpiry);
    await prefs.remove(_keyRole);

    _cachedToken = null;
    _cachedRefreshToken = null;
    _cachedRole = null;
  }

  // Kiểm tra đăng nhập
  static Future<bool> isLoggedIn() async {
    final token = await getRefreshToken();
    return token != null;
  }

  // Xử lý khi token hết hạn
  static Future<void> _handleTokenExpired() async {
    await logout();
    onTokenExpired?.call();
  }
}
