import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import '../api/api_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

   bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final ProfileApi _api = ProfileApi();

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final token = await AuthStorage.getToken();
      if (token == null) throw Exception("Chưa đăng nhập");
      
      final userData = await _api.getProfile(token);
      _user = userData;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
