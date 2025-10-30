import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/review.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class ReviewDetailForm extends StatelessWidget {
  final Review review;

  const ReviewDetailForm({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột Avatar và Rating
          SizedBox(
            width: 120,
            child: Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 16),
                _buildRatingChip(review.rating),
                const SizedBox(height: 8),
                _buildIdBadge(review.reviewId),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Cột thông tin chi tiết
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đánh giá #${review.reviewId}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoTile(
                  icon: Icons.person_rounded,
                  label: 'Người dùng',
                  value: '${review.fullName}',
                  isPrimary: true,
                ),
                _buildInfoTile(
                  icon: Icons.fastfood_rounded,
                  label: 'Món ăn',
                  value: '${review.foodName}',
                ),
                _buildInfoTile(
                  icon: Icons.star_rounded,
                  label: 'Đánh giá',
                  value: '${review.rating}/5 sao',
                ),
                _buildInfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Ngày đánh giá',
                  value: formatDateTime(review.createdAt),
                ),
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildCommentSection(review.comment),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AVATAR
  Widget _buildAvatar() => CircleAvatar(
    radius: 48,
    backgroundColor: AppColor.primary.withValues(alpha: 0.1),
    child: Icon(Icons.person_rounded, size: 48, color: AppColor.primary),
  );

  // RATING CHIP
  Widget _buildRatingChip(int rating) {
    Color ratingColor;
    if (rating >= 4) {
      ratingColor = Colors.green.shade600;
    } else if (rating >= 3) {
      ratingColor = Colors.orange.shade600;
    } else {
      ratingColor = Colors.red.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ratingColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ratingColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              rating,
              (index) => Icon(Icons.star_rounded, size: 16, color: ratingColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$rating/5',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: ratingColor,
            ),
          ),
        ],
      ),
    );
  }

  // ID BADGE
  Widget _buildIdBadge(int id) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      'ID: $id',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.blue.shade700,
      ),
    ),
  );

  // INFO TILE
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
                    color: isPrimary ? AppColor.primary : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =COMMENT SECTION
  Widget _buildCommentSection(String comment) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.comment_rounded, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 8),
          Text(
            'Nhận xét',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          comment,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
            height: 1.6,
          ),
        ),
      ),
    ],
  );
}
