import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/user.dart';
import '../api/api_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  final ProfileApi _api = ProfileApi();

  Future<void> loadProfile(String token) async {
    try {
      final userData = await _api.getProfile(token);
      if (userData != null) {
        _user = userData;
        notifyListeners();
      } else {
        debugPrint("Không thể tải user profile");
      }
    } catch (e) {
      debugPrint("Lỗi load profile: $e");
    }
  }
}
