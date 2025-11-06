class Login {
  final String token;
  final DateTime? expiry;
  final String refreshToken;
  final DateTime? refreshExpiry;
  final String role;

  Login({
    required this.token,
    this.expiry,
    required this.refreshToken,
    this.refreshExpiry,
    required this.role,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      token: json['token'] as String? ?? '',
      expiry: _safeParseDateTime(json['tokenExpiry']),
      refreshToken: json['refreshToken'] as String? ?? '',
      refreshExpiry: _safeParseDateTime(json['refreshTokenExpiry']),
      role: json['role'] as String? ?? 'User',
    );
  }

  static DateTime? _safeParseDateTime(dynamic jsonDate) {
    if (jsonDate is String && jsonDate.isNotEmpty) {
      return DateTime.tryParse(jsonDate);
    }
    return null;
  }
}
