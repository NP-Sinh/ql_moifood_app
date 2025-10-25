import 'package:flutter/foundation.dart';
import '../api/api_services.dart';
import '../models/user.dart';

class UserListViewModel extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<User> _users = [];
  List<User> get users => _users;

  Future<void> getUsers() async {
    try {
      _users = await _api.getUsers();
    } catch (e) {
      _users = [];
    } finally {
      notifyListeners();
    }
  }
}
