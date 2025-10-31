import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/reviews_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/views/review/controller/review_controller.dart';
import 'package:ql_moifood_app/views/review/widgets/review_empty.dart';
import 'package:ql_moifood_app/views/review/widgets/review_list_item.dart';

class ReviewView extends StatefulWidget {
  static const String routeName = '/review';
  const ReviewView({super.key});

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  late final ReviewController _controller;

  // Filter state
  Map<String, dynamic> _currentFilters = {};
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _controller = ReviewController(context);
    Future.microtask(() => _controller.loadAllReviews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('review_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),
          if (_isFiltered) _buildFilterInfo(),
          Expanded(child: _buildReviewsList()),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Đánh giá',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Consumer<ReviewViewModel>(
            builder: (context, vm, _) => CustomButton(
              label: "Lọc đánh giá",
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
                size: 20,
              ),
              height: 48,
              fontSize: 14,
              gradientColors: AppColor.btnAdd,
              onTap: (vm.isLoadingAll || vm.isLoadingFilter)
                  ? null
                  : () => _controller.showFilterDialog(
                      currentFilters: _currentFilters,
                      onApply: (filters) {
                        setState(() {
                          _currentFilters = filters;
                          _isFiltered = filters.values.any(
                            (value) => value != null,
                          );
                        });
                        if (_isFiltered) {
                          _controller.loadFilteredReviews(
                            foodName: filters['foodName'],
                            fullName: filters['fullName'],
                            minRating: filters['minRating'],
                            maxRating: filters['maxRating'],
                            fromDate: filters['fromDate'],
                            toDate: filters['toDate'],
                          );
                        } else {
                          _controller.loadAllReviews();
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // FILTER INFO
  Widget _buildFilterInfo() {
    final activeFilters = <String>[];

    if (_currentFilters['foodName'] != null) {
      activeFilters.add('Món #${_currentFilters['foodName']}');
    }
    if (_currentFilters['fullName'] != null) {
      activeFilters.add('User #${_currentFilters['fullName']}');
    }
    if (_currentFilters['minRating'] != null ||
        _currentFilters['maxRating'] != null) {
      final min = _currentFilters['minRating'] ?? 1;
      final max = _currentFilters['maxRating'] ?? 5;
      activeFilters.add('$min-$max ⭐');
    }
    if (_currentFilters['fromDate'] != null ||
        _currentFilters['toDate'] != null) {
      activeFilters.add('Có lọc thời gian');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_rounded, size: 20, color: AppColor.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bộ lọc: ${activeFilters.join(', ')}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () {
              setState(() {
                _currentFilters = {};
                _isFiltered = false;
              });
              _controller.loadAllReviews();
            },
            tooltip: 'Xóa bộ lọc',
          ),
        ],
      ),
    );
  }

  //  REVIEWS LIST
  Widget _buildReviewsList() {
    return Consumer<ReviewViewModel>(
      builder: (context, vm, _) {
        final reviews = _isFiltered ? vm.filteredReviews : vm.allReviews;
        final isLoading = _isFiltered ? vm.isLoadingFilter : vm.isLoadingAll;

        if (isLoading && reviews.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage != null && reviews.isEmpty) {
          return ReviewEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _isFiltered
                ? () => _controller.loadFilteredReviews(
                    foodName: _currentFilters['foodName'],
                    fullName: _currentFilters['fullName'],
                    minRating: _currentFilters['minRating'],
                    maxRating: _currentFilters['maxRating'],
                    fromDate: _currentFilters['fromDate'],
                    toDate: _currentFilters['toDate'],
                  )
                : _controller.loadAllReviews,
          );
        }

        if (reviews.isEmpty) {
          return ReviewEmpty(
            message: _isFiltered
                ? 'Không tìm thấy kết quả nào.'
                : 'Chưa có đánh giá nào.',
            icon: _isFiltered
                ? Icons.search_off_rounded
                : Icons.star_outline_rounded,
            onRefresh: _isFiltered
                ? () => _controller.loadFilteredReviews(
                    foodName: _currentFilters['foodName'],
                    fullName: _currentFilters['fullName'],
                    minRating: _currentFilters['minRating'],
                    maxRating: _currentFilters['maxRating'],
                    fromDate: _currentFilters['fromDate'],
                    toDate: _currentFilters['toDate'],
                  )
                : _controller.loadAllReviews,
          );
        }

        // List view
        return RefreshIndicator(
          onRefresh: _isFiltered
              ? () => _controller.loadFilteredReviews(
                  foodName: _currentFilters['foodName'],
                  fullName: _currentFilters['fullName'],
                  minRating: _currentFilters['minRating'],
                  maxRating: _currentFilters['maxRating'],
                  fromDate: _currentFilters['fromDate'],
                  toDate: _currentFilters['toDate'],
                )
              : _controller.loadAllReviews,
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ReviewListItem(
                key: ValueKey(review.reviewId),
                review: review,
                onView: () => _controller.showViewReviewModal(review),
                onDelete: () => _controller.confirmDeleteReview(review),
              );
            },
          ),
        );
      },
    );
  }
}
