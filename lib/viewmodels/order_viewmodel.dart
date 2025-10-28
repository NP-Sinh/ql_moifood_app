import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_order.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

// Định nghĩa các trạng thái đơn hàng
class OrderStatus {
  static const String pending = 'Pending';
  static const String confirmed = 'Confirmed';
  static const String cancelled = 'Cancelled';
  static const String completed = 'Completed';

  // Danh sách các trạng thái để tạo Tab
  static const List<String> values = [pending, confirmed, completed, cancelled];
}

class OrderViewModel extends ChangeNotifier {
  final ApiOrder _api = ApiOrder();

  // Dùng Map để lưu danh sách đơn hàng theo từng trạng thái
  final Map<String, List<Order>> _ordersByStatus = {
    OrderStatus.pending: [],
    OrderStatus.confirmed: [],
    OrderStatus.completed: [],
    OrderStatus.cancelled: [],
  };

  List<Order> getOrdersByStatus(String status) => _ordersByStatus[status] ?? [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isFetchingDetails = false;
  bool get isFetchingDetails => _isFetchingDetails;

  // Lấy token
  Future<String?> _getToken() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) {
      _errorMessage = 'Phiên đăng nhập hết hạn';
      return null;
    }
    return token;
  }

  // tải danh sách đơn hàng theo trạng thái
  Future<void> fetchOrdersByStatus(String status) async {
    if (_ordersByStatus[status]?.isEmpty ?? true) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final token = await _getToken();
      if (token == null) return;

      final orders = await _api.getAllOrder(status: status, token: token);
      _ordersByStatus[status] = orders;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _ordersByStatus[status] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tải lại tất cả các danh sách
  Future<void> fetchAllOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await Future.wait(
        OrderStatus.values.map((status) => fetchOrdersByStatus(status)),
      );
    } catch (e) {
      _errorMessage = "Lỗi tải tất cả đơn hàng: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Lấy chi tiết đơn hàng
  Future<Order?> fetchOrderDetails(int orderId) async {
    _isFetchingDetails = true; 
    _errorMessage = null;
    notifyListeners();

    Order? detailedOrder;

    try {
      final token = await _getToken();
      if (token == null) return null; 
      detailedOrder = await _api.getOrderById(orderId: orderId, token: token);

      if (detailedOrder == null) {
        _errorMessage = 'Không tìm thấy chi tiết đơn hàng #$orderId';
      }
    } catch (e) {
      _errorMessage = 'Lỗi tải chi tiết đơn hàng: ${e.toString()}';
      detailedOrder = null;
    } finally {
      _isFetchingDetails = false;
      notifyListeners();
    }
    return detailedOrder; 
  }

  // Cập nhật trạng thái đơn hàng
  Future<bool> updateOrderStatus({
    required int orderId,
    required String oldStatus,
    required String newStatus,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final success = await _api.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
        token: token,
      );

      if (success) {
        await Future.wait([
          fetchOrdersByStatus(oldStatus),
          fetchOrdersByStatus(newStatus),
        ]);
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
}
