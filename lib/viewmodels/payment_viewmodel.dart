import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_payment.dart';
import 'package:ql_moifood_app/models/payment_method.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

class PaymentViewModel extends ChangeNotifier {
  final ApiPayment _api = ApiPayment();

  // Trạng thái tải chung
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái cho Thêm/Sửa
  bool _isModifying = false;
  bool get isModifying => _isModifying;

  // Trạng thái cho Xóa
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  // Trạng thái lỗi
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Dữ liệu
  List<PaymentMethod> _paymentMethods = [];
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  // lấy Token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn hoặc không hợp lệ.';
      notifyListeners();
      return null;
    }
    _errorMessage = null;
    return token;
  }

  /// Lấy tất cả phương thức thanh toán
  Future<void> fetchAllPaymentMethods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _getToken();
    if (token == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _paymentMethods = await _api.getAllPaymentMethod(token: token);
    } catch (e) {
      _errorMessage = "Lỗi tải PTTT: ${e.toString()}";
      _paymentMethods = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lưu (Thêm mới hoặc Cập nhật)
  // id = 0 nghĩa là Thêm mới
  Future<bool> modifyPaymentMethod({
    required int id,
    required String name,
  }) async {
    _isModifying = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _getToken();
    if (token == null) {
      _isModifying = false;
      notifyListeners();
      return false;
    }

    bool success = false;
    try {
      success = await _api.modifyPaymentMethod(
        id: id,
        name: name,
        token: token,
      );

      if (success) {
        await fetchAllPaymentMethods();
      } else {
        _errorMessage = "Lưu PTTT thất bại.";
      }
    } catch (e) {
      _errorMessage = "Lỗi lưu PTTT: ${e.toString()}";
      success = false;
    } finally {
      _isModifying = false;
      notifyListeners();
    }
    return success;
  }

  // Xóa phương thức thanh toán
  Future<bool> deletePaymentMethod(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _getToken();
    if (token == null) {
      _isDeleting = false;
      notifyListeners();
      return false;
    }

    bool success = false;
    try {
      success = await _api.deletePaymentMethod(id: id, token: token);
      if (success) {
        _paymentMethods.removeWhere((method) => method.methodId == id);
      } else {
        _errorMessage = "Xóa PTTT thất bại.";
      }
    } catch (e) {
      _errorMessage = "Lỗi xóa PTTT: ${e.toString()}";
      success = false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
    return success;
  }
}
