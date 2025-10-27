import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class FoodListItem extends StatefulWidget {
  final Food food;
  final bool isDeleted;
  final bool isAvailable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onToggleAvailable;

  const FoodListItem({
    super.key,
    required this.food,
    this.isDeleted = false,
    this.isAvailable = true,
    this.onEdit,
    this.onDelete,
    this.onRestore,
    this.onToggleAvailable,
  });

  @override
  State<FoodListItem> createState() => _FoodListItemState();
}

class _FoodListItemState extends State<FoodListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Xác định màu sắc dựa trên trạng thái
    final Color hoverColor = widget.isDeleted
        ? Colors.grey.shade400
        : AppColor.orange;
    final List<Color> bgGradient = widget.isDeleted
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];

    final bool isDimmed = !widget.isAvailable && !widget.isDeleted;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? hoverColor.withValues(alpha: 0.3)
                : (widget.isDeleted
                      ? Colors.grey.shade300
                      : Colors.grey.shade200),
            width: 2,
          ),
          boxShadow: widget.isDeleted
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: _isHovered
                        ? hoverColor.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: Offset(0, _isHovered ? 8 : 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon với gradient background
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.food.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  // Thêm hiệu ứng xám nếu ngừng bán
                  color: isDimmed ? Colors.grey.withValues(alpha: 0.5) : null,
                  colorBlendMode: isDimmed ? BlendMode.saturation : null,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.grey.shade400,
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
                      widget.food.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.isDeleted
                            ? Colors.black54
                            : (isDimmed
                                  ? Colors.grey.shade600
                                  : Colors.black87),
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Giá tiền
                    Text(
                      formatVND(widget.food.price),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.isDeleted
                            ? AppColor.primary.withValues(alpha: 0.5)
                            : AppColor.primary,
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Mô tả
                    Text(
                      widget.food.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              widget.isDeleted ? _buildRestoreButton() : _buildActiveButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho các nút Sửa và Xóa
  Widget _buildActiveButtons() {
    final toggleButton = CustomButton(
      width: 44,
      height: 44,
      iconSize: 22,
      icon: Icon(
        widget.isAvailable
            ? Icons.pause_circle_outline_rounded
            : Icons.play_circle_outline_rounded,
        color: Colors.white,
      ),
      tooltip: widget.isAvailable ? 'Ngừng bán' : 'Mở bán',
      gradientColors: widget.isAvailable
          ? [Colors.amber.shade600, Colors.amber.shade800]
          : [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onToggleAvailable,
      borderRadius: 12,
    );

    // Nút Sửa
    final editButton = CustomButton(
      tooltip: "Sửa",
      width: 44,
      height: 44,
      iconSize: 22,
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
      onTap: widget.onEdit,
      borderRadius: 12,
    );

    // Nút Xóa
    final deleteButton = CustomButton(
      tooltip: "Xóa",
      width: 44,
      height: 44,
      iconSize: 22,
      icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      gradientColors: [Colors.redAccent.shade200, Colors.redAccent.shade400],
      onTap: widget.onDelete,
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

  /// Widget cho nút Khôi phục
  Widget _buildRestoreButton() {
    return CustomButton(
      width: 44,
      height: 44,
      iconSize: 22,
      icon: const Icon(Icons.restore_from_trash_rounded, color: Colors.white),
      gradientColors: [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onRestore,
      borderRadius: 12,
    );
  }
}
