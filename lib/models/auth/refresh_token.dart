class RefreshToken {
  final String token;
  final DateTime expiry;
  final String refreshToken;
  final DateTime refreshExpiry;

  RefreshToken({
    required this.token,
    required this.expiry,
    required this.refreshToken,
    required this.refreshExpiry,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    token: json['token'] as String? ?? '',
    expiry: DateTime.parse(json['tokenExpiry']),
    refreshToken: json['refreshToken'],
    refreshExpiry: DateTime.parse(json['refreshTokenExpiry']),
  );
}
