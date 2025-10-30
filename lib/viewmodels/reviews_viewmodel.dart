import 'package:flutter/material.dart';
import 'package:ql_moifood_app/api/api_reviews.dart';
import 'package:ql_moifood_app/models/review.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';

class ReviewViewModel extends ChangeNotifier {
  final ApiReviews _api = ApiReviews();

  // Tất cả đánh giá
  bool _isLoadingAll = false;
  bool get isLoadingAll => _isLoadingAll;
  List<Review> _allReviews = [];
  List<Review> get allReviews => _allReviews;

  // Lọc đánh giá
  bool _isLoadingFilter = false;
  bool get isLoadingFilter => _isLoadingFilter;
  List<Review> _filteredReviews = [];
  List<Review> get filteredReviews => _filteredReviews;

  // Trạng thái chung
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  // Lấy token
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

  // Lấy tất cả review
  Future<void> fetchAllReviews() async {
    _isLoadingAll = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingAll = false;
        notifyListeners();
        return;
      }
      _allReviews = await _api.getAllReviews(token: token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _allReviews = [];
    } finally {
      _isLoadingAll = false;
      notifyListeners();
    }
  }

  // Lọc review
  Future<void> filterReviews({
     String? foodName,     
  String? fullName,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    _isLoadingFilter = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _isLoadingFilter = false;
        notifyListeners();
        return;
      }
      _filteredReviews = await _api.filterReviews(
        token: token,
        foodName: foodName,
        fullName: fullName,
        minRating: minRating,
        maxRating: maxRating,
        fromDate: fromDate,
        toDate: toDate,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _filteredReviews = [];
    } finally {
      _isLoadingFilter = false;
      notifyListeners();
    }
  }

  // Xóa một review
  Future<bool> deleteReview(int reviewId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();
    bool success = false;

    try {
      final token = await _getToken();
      if (token == null) {
        _isDeleting = false;
        notifyListeners();
        return false;
      }

      success = await _api.deleteReview(reviewId: reviewId, token: token);
      _errorMessage = null;

      if (success) {
        _allReviews.removeWhere((r) => r.reviewId == reviewId);
        _filteredReviews.removeWhere((r) => r.reviewId == reviewId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      success = false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
    return success;
  }
}
