import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_category.dart';
import 'package:ql_moifood_app/models/category.dart';

class CategoryViewModel extends ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiCategory _api = ApiCategory();

  List<Category> _category = [];
  List<Category> get category => _category;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  //danh sách danh mục
  Future<void> fetchCategories() async {
    _setLoading(true);
    _setError(null);
    try {
      _category = await _api.getAllCategory();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
