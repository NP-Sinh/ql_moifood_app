import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/review.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class ReviewListItem extends StatefulWidget {
  final Review review;
  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const ReviewListItem({
    super.key,
    required this.review,
    this.onView,
    this.onDelete,
  });

  @override
  State<ReviewListItem> createState() => _ReviewListItemState();
}

class _ReviewListItemState extends State<ReviewListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: _buildDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(child: _buildContent()),
              const SizedBox(width: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // DECORATION
  BoxDecoration _buildDecoration() => BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade50],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _isHovered
          ? AppColor.orange.withValues(alpha: 0.3)
          : Colors.grey.shade200,
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: _isHovered
            ? AppColor.orange.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        blurRadius: _isHovered ? 20 : 10,
        offset: Offset(0, _isHovered ? 8 : 4),
        spreadRadius: _isHovered ? 2 : 0,
      ),
    ],
  );

  // AVATAR
  Widget _buildAvatar() => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: _isHovered
              ? AppColor.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: CircleAvatar(
      radius: 32,
      backgroundColor: AppColor.primary.withValues(alpha: 0.1),
      child: Icon(Icons.person_rounded, size: 32, color: AppColor.primary),
    ),
  );

  // CONTENT
  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeader(),
      const SizedBox(height: 8),
      _buildRating(),
      if (widget.review.comment.isNotEmpty) ...[
        const SizedBox(height: 8),
        _buildComment(),
      ],
      const SizedBox(height: 8),
      _buildFooter(),
    ],
  );

  Widget _buildHeader() => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.review.fullName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Món ăn: ${widget.review.foodName}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
      _buildReviewIdBadge(),
    ],
  );

  Widget _buildReviewIdBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.shade200),
    ),
    child: Text(
      'ID: ${widget.review.reviewId}',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.blue.shade700,
      ),
    ),
  );

  // RATING
  Widget _buildRating() => Row(
    children: [
      ...List.generate(
        5,
        (index) => Icon(
          index < widget.review.rating
              ? Icons.star_rounded
              : Icons.star_outline_rounded,
          color: index < widget.review.rating
              ? Colors.amber.shade600
              : Colors.grey.shade400,
          size: 22,
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _getRatingColor(widget.review.rating).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getRatingColor(widget.review.rating).withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          '${widget.review.rating}/5',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _getRatingColor(widget.review.rating),
          ),
        ),
      ),
    ],
  );

  Color _getRatingColor(int rating) {
    if (rating >= 4) return Colors.green.shade600;
    if (rating >= 3) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // COMMENT
  Widget _buildComment() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Text(
      widget.review.comment,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
  );

  // FOOTER
  Widget _buildFooter() => Row(
    children: [
      Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade500),
      const SizedBox(width: 6),
      Text(
        formatDateTime(widget.review.createdAt),
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
    ],
  );

  // ACTION BUTTONS
  Widget _buildActionButtons() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomButton(
        tooltip: "Xem chi tiết",
        width: 44,
        height: 44,
        iconSize: 22,
        icon: const Icon(Icons.visibility_rounded, color: Colors.white),
        gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
        onTap: widget.onView,
        borderRadius: 12,
      ),
      const SizedBox(width: 8),
      CustomButton(
        tooltip: "Xóa đánh giá",
        width: 44,
        height: 44,
        iconSize: 22,
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        gradientColors: [Colors.redAccent.shade200, Colors.redAccent.shade400],
        onTap: widget.onDelete,
        borderRadius: 12,
      ),
    ],
  );
}
