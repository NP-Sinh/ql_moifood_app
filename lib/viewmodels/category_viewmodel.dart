import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_category.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

class CategoryViewModel extends ChangeNotifier {
  final ApiCategory _api = ApiCategory();

  List<Category> _category = [];
  List<Category> get category => _category;

  List<Category> _deletedCategories = [];
  List<Category> get deletedCategories => _deletedCategories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Lấy token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn';
      return null;
    }
    return token;
  }

  // Lấy danh sách danh mục
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _api.getAllCategory(),
        _api.getDeletedCategory(),
      ]);

      _category = results[0];
      _deletedCategories = results[1];
    } catch (e) {
      _errorMessage = e.toString();
      _category = [];
      _deletedCategories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm danh mục mới
  Future<bool> addCategory({
    required String name,
    required String description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.modify(
        id: 0,
        name: name,
        description: description,
        token: token,
      );

      if (success) {
        await fetchCategories();
        return true;
      }

      _errorMessage = 'Thêm danh mục thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật danh mục
  Future<bool> updateCategory({
    required int categoryId,
    required String name,
    required String description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.modify(
        id: categoryId,
        name: name,
        description: description,
        token: token,
      );

      if (success) {
        await fetchCategories();
        return true;
      }

      _errorMessage = 'Cập nhật danh mục thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa danh mục
  Future<bool> deleteCategory({required int categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.deleteCategory(id: categoryId, token: token);

      if (success) {
        await fetchCategories();
        return true;
      }

      _errorMessage = 'Xóa danh mục thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Khôi phục danh mục
  Future<bool> restoreCategory({required int categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.restoreCategory(id: categoryId, token: token);

      if (success) {
        await fetchCategories();
        return true;
      }

      _errorMessage = 'Khôi phục danh mục thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset
  void reset() {
    _category = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
