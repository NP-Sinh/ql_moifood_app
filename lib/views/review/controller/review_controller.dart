import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/review.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/reviews_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/views/review/modal/review_detail_form.dart';
import 'package:ql_moifood_app/views/review/modal/review_filter_form.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class ReviewController {
  final BuildContext context;
  late final ReviewViewModel _viewModel;

  ReviewController(this.context) {
    _viewModel = context.read<ReviewViewModel>();
  }

  // LOAD DATA
  Future<void> loadAllReviews() async {
    await _viewModel.fetchAllReviews();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  Future<void> loadFilteredReviews({
    String? foodName,
    String? fullName,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    await _viewModel.filterReviews(
      foodName: foodName,
      fullName: fullName,
      minRating: minRating,
      maxRating: maxRating,
      fromDate: fromDate,
      toDate: toDate,
    );
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // DELETE REVIEW
  void confirmDeleteReview(Review review) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa đánh giá này không?',
      confirmText: 'Xóa',
      confirmColor: Colors.redAccent,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.deleteReview(review.reviewId);
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã xóa đánh giá thành công'
                : _viewModel.errorMessage ?? 'Xóa thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }

  // VIEW DETAIL
  void showViewReviewModal(Review review) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Đánh giá',
      child: ReviewDetailForm(review: review),
      secondaryAction: CustomButton(
        label: 'Đóng',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
      ),
    );
  }

  // FILTER DIALOG
  void showFilterDialog({
    required Map<String, dynamic> currentFilters,
    required Function(Map<String, dynamic>) onApply,
  }) {
    AppUtils.showBaseModal(
      context,
      title: 'Lọc đánh giá',
      child: ReviewFilterForm(
        currentFilters: currentFilters,
        onApply: (filters) {
          Navigator.pop(context);
          onApply(filters);
        },
      ),
      secondaryAction: CustomButton(
        label: 'Hủy',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      width: 800,
      maxHeight: 600,
    );
  }
}
