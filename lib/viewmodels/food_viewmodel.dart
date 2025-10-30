import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import '../api/api_food.dart';
import '../models/food.dart';

class FoodViewModel extends ChangeNotifier {

  List<Food> _availableFoods = [];
  List<Food> get availableFoods => _availableFoods;

  List<Food> _deletedFoods = [];
  List<Food> get deletedFoods => _deletedFoods;

  List<Food> _unavailableFoods = [];
  List<Food> get unavailableFoods => _unavailableFoods;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final FoodApi _api = FoodApi();

  // Lấy token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn';
      return null;
    }
    return token;
  }

  // lấy danh sách món ăn dang hoạt động và đã xóa
  Future<void> fetchFoods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _api.getAllFood(isActive: false, isAvailable: true),
        _api.getAllFood(isActive: false, isAvailable: false),
        _api.getAllFood(isActive: true),
      ]);

      _availableFoods = results[0];
      _unavailableFoods = results[1];
      _deletedFoods = results[2];
    } catch (e) {
      _errorMessage = e.toString();
      _availableFoods = [];
      _unavailableFoods = [];
      _deletedFoods = [];
      _deletedFoods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tìm kiếm food theo từ khóa
  Future<void> searchFoods(String keyword) async {
    // Nếu keyword rỗng, tải lại toàn bộ danh sách
    if (keyword.trim().isEmpty) {
      await fetchFoods();
      return;
    }

     _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _getToken();
    if (token == null) {
      _errorMessage = "Lỗi xác thực, vui lòng đăng nhập lại.";
      _isLoading = false;
      return;
    }

    try {
    final foods = await _api.searchFood(keyword: keyword, token: token);

    _availableFoods = foods
        .where((food) => food.isAvailable)
        .toList();
    
    _unavailableFoods = foods
        .where((food) => !food.isAvailable)
        .toList();
    
    _deletedFoods = foods
        .where((food) => food.isActive)
        .toList();
    
  } catch (e) {
    _errorMessage = "Lỗi tìm kiếm: ${e.toString()}";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

  // Hàm set trạng thái Bán / Ngừng bán
  Future<bool> setAvailableStatus({
    required int foodId,
    required bool isAvailable,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.setAvailableStatus(
        id: foodId,
        isAvailable: isAvailable,
        token: token,
      );

      if (success) {
        await fetchFoods();
        return true;
      }

      _errorMessage = 'Cập nhật trạng thái thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm / Sửa món ăn
  Future<bool> modifyFood({
    required int id,
    required String name,
    required String description,
    required double price,
    required int categoryId,
    XFile? imageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.modifyFood(
        id: id,
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageFile: imageFile,
        token: token,
      );

      if (success) {
        await fetchFoods();
        return true;
      }
      _errorMessage = id == 0 ? 'Thêm món ăn thất bại' : 'Cập nhật thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa mềm món ăn
  Future<bool> deleteFood({required int foodId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.setActiveStatus(
        id: foodId,
        isActive: true,
        token: token,
      );

      if (success) {
        await fetchFoods();
        return true;
      }

      _errorMessage = 'Xóa món ăn thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Khôi phục món ăn
  Future<bool> restoreFood({required int foodId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.setActiveStatus(
        id: foodId,
        isActive: false,
        token: token,
      );

      if (success) {
        await fetchFoods();
        return true;
      }

      _errorMessage = 'Khôi phục món ăn thất bại';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
