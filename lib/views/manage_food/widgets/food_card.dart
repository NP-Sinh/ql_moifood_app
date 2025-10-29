import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class FoodCard extends StatefulWidget {
  final Food food;
  final bool isDeleted;
  final bool isAvailable;
  final bool isHovered;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onToggleAvailable;

  const FoodCard({
    super.key,
    required this.food,
    this.isDeleted = false,
    this.isAvailable = true,
    this.isHovered = false,
    this.onEdit,
    this.onDelete,
    this.onRestore,
    this.onToggleAvailable,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.isDeleted
        ? Colors.grey.shade400
        : AppColor.orange;
    final List<Color> bgGradient = widget.isDeleted
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];
    final bool isDimmed = !widget.isAvailable && !widget.isDeleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isHovered
              ? hoverColor.withValues(alpha: 0.3)
              : (widget.isDeleted
                    ? Colors.grey.shade300
                    : Colors.grey.shade200),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isHovered
                ? hoverColor.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: widget.isHovered ? 20 : 10,
            offset: Offset(0, widget.isHovered ? 8 : 4),
            spreadRadius: widget.isHovered ? 2 : 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ảnh món ăn
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.food.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                color: isDimmed ? Colors.grey.withValues(alpha: 0.5) : null,
                colorBlendMode: isDimmed ? BlendMode.saturation : null,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Thông tin món ăn
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Tên món ăn
                    widget.food.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: widget.isDeleted
                          ? Colors.black54
                          : (isDimmed ? Colors.grey.shade600 : Colors.black87),
                      decoration: widget.isDeleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Giá tiền
                    formatVND(widget.food.price),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isDeleted
                          ? AppColor.primary.withValues(alpha: 0.5)
                          : (isDimmed
                                ? AppColor.primary.withValues(alpha: 0.6)
                                : AppColor.primary),
                      decoration: widget.isDeleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (widget.food.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      // Mô tả
                      widget.food.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  // danh mục
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isDeleted
                          ? Colors.grey.shade200
                          : (isDimmed
                                ? AppColor.orange.withValues(alpha: 0.1)
                                : AppColor.orange.withValues(alpha: 0.15)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category_rounded,
                          size: 14,
                          color: widget.isDeleted
                              ? Colors.grey.shade500
                              : (isDimmed
                                    ? AppColor.orange.withValues(alpha: 0.7)
                                    : AppColor.orange),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.food.categoryName ?? "Chưa phân loại",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isDeleted
                                  ? Colors.grey.shade500
                                  : (isDimmed
                                        ? AppColor.orange.withValues(alpha: 0.7)
                                        : AppColor.orange),
                              decoration: widget.isDeleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            widget.isDeleted ? _buildRestoreButton() : _buildActiveButtons(),
          ],
        ),
      ),
    );
  }

  // tạo nút bấm
  Widget _buildActiveButtons() {
    final toggleButton = CustomButton(
      tooltip: widget.isAvailable ? 'Ngừng bán' : 'Mở bán',
      icon: Icon(
        widget.isAvailable
            ? Icons.pause_circle_outline_rounded
            : Icons.play_circle_outline_rounded,
        color: Colors.white,
      ),
      gradientColors: widget.isAvailable
          ? [Colors.amber.shade600, Colors.amber.shade800]
          : [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onToggleAvailable,
      width: 44,
      height: 44,
      iconSize: 22,
      borderRadius: 12,
    );

    final editButton = CustomButton(
      tooltip: "Sửa",
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
      onTap: widget.onEdit,
      width: 44,
      height: 44,
      iconSize: 22,
      borderRadius: 12,
    );

    final deleteButton = CustomButton(
      tooltip: "Xóa",
      icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      gradientColors: [Colors.redAccent.shade200, Colors.redAccent.shade400],
      onTap: widget.onDelete,
      width: 44,
      height: 44,
      iconSize: 22,
      borderRadius: 12,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        toggleButton,
        const SizedBox(width: 8),
        editButton,
        const SizedBox(width: 8),
        deleteButton,
      ],
    );
  }

  Widget _buildRestoreButton() {
    return CustomButton(
      tooltip: "Khôi phục",
      icon: const Icon(Icons.restore_from_trash_rounded, color: Colors.white),
      gradientColors: [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onRestore,
      width: 44,
      height: 44,
      iconSize: 22,
      borderRadius: 12,
    );
  }
}
