import 'package:ql_moifood_app/models/auth/refresh_token.dart';

class Login {
  final RefreshToken refreshToken;

  Login({required this.refreshToken});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(refreshToken: RefreshToken.fromJson(json));
  }
}