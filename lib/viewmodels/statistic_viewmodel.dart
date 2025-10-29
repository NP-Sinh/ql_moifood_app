import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_statistic.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart'; 

class StatisticViewModel extends ChangeNotifier {
  final ApiStatistic _api = ApiStatistic();

  // Revenue
  bool _isLoadingRevenue = false;
  bool get isLoadingRevenue => _isLoadingRevenue;
  dynamic _revenueData;
  dynamic get revenueData => _revenueData;

  // Order Count
  bool _isLoadingOrderCount = false;
  bool get isLoadingOrderCount => _isLoadingOrderCount;
  dynamic _orderCountData;
  dynamic get orderCountData => _orderCountData;

  // Food Stats
  bool _isLoadingFoodStats = false;
  bool get isLoadingFoodStats => _isLoadingFoodStats;
  dynamic _foodStatsData;
  dynamic get foodStatsData => _foodStatsData;

  // User Spending
  bool _isLoadingUserSpending = false;
  bool get isLoadingUserSpending => _isLoadingUserSpending;
  dynamic _userSpendingData;
  dynamic get userSpendingData => _userSpendingData;

  // Error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // lấy token
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

  // --- Fetch Methods ---

  Future<void> fetchRevenue({
    DateTime? fromDate,
    DateTime? toDate,
    required String groupBy,
  }) async {
    _isLoadingRevenue = true;
    _errorMessage = null; 
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingRevenue = false; 
        notifyListeners(); 
        return; 
      }
      _revenueData = await _api.getRevenue(
        token: token,
        fromDate: fromDate,
        toDate: toDate,
        groupBy: groupBy,
      );
      _errorMessage = null; 
    } catch (e) {
      _errorMessage = e.toString();
      _revenueData = null; 
    } finally {
      _isLoadingRevenue = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderCount({
    DateTime? fromDate,
    DateTime? toDate,
    required String groupBy,
  }) async {
    _isLoadingOrderCount = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
         _isLoadingOrderCount = false;
         notifyListeners();
         return;
      }
      _orderCountData = await _api.getOrderCount(
        token: token,
        fromDate: fromDate,
        toDate: toDate,
        groupBy: groupBy,
      );
      _errorMessage = null; 
    } catch (e) {
      _errorMessage = e.toString();
      _orderCountData = null;
    } finally {
      _isLoadingOrderCount = false;
      notifyListeners();
    }
  }

  Future<void> fetchFoodOrderStats({
    required int top,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    _isLoadingFoodStats = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
       if (token == null) {
         _isLoadingFoodStats = false;
         notifyListeners();
         return;
      }
      _foodStatsData = await _api.getFoodOrderStats(
        token: token,
        top: top,
        fromDate: fromDate,
        toDate: toDate,
      );
      _errorMessage = null; 
    } catch (e) {
      _errorMessage = e.toString();
      _foodStatsData = null;
    } finally {
      _isLoadingFoodStats = false;
      notifyListeners();
    }
  }
}