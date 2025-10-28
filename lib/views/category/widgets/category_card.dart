import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final bool isDeleted;
  final bool isHovered;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;

  const CategoryCard({
    super.key,
    required this.category,
    this.isDeleted = false,
    this.isHovered = false,
    this.onEdit,
    this.onDelete,
    this.onRestore,
  });

   @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.isDeleted
        ? Colors.grey.shade400
        : AppColor.orange;
    final List<Color> bgGradient = widget.isDeleted
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];
    final List<Color> iconGradient = widget.isDeleted
        ? [Colors.grey.shade500, Colors.grey.shade600]
        : [AppColor.orange, AppColor.orange.withValues(alpha: 0.8)];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // Bỏ margin
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
              : (widget.isDeleted ? Colors.grey.shade300 : Colors.grey.shade200),
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
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: iconGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.last.withValues(alpha: 0.3),
                    blurRadius: 8, 
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon( 
                Icons.category_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Thông tin danh mục
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( // Tên danh mục
                    widget.category.name,
                    style: TextStyle(
                      fontSize: 17, // Tăng size
                      fontWeight: FontWeight.bold,
                      color: widget.isDeleted ? Colors.black54 : Colors.black87,
                      decoration: widget.isDeleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.category.description.isNotEmpty) ...[ 
                    const SizedBox(height: 4),
                    Text( // Mô tả
                      widget.category.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        decoration: widget.isDeleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          tooltip: "Sửa",
          width: 44, height: 44, iconSize: 22,
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
          onTap: widget.onEdit, 
          borderRadius: 12,
        ),
        const SizedBox(width: 8),
        CustomButton(
          tooltip: "Xóa",
          width: 44, height: 44, iconSize: 22,
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          gradientColors: [Colors.redAccent.shade200, Colors.redAccent.shade400],
          onTap: widget.onDelete,
          borderRadius: 12,
        ),
      ],
    );
  }

  Widget _buildRestoreButton() {
    return CustomButton(
      tooltip: "Khôi phục",
      width: 44, height: 44, iconSize: 22,
      icon: const Icon(Icons.restore_from_trash_rounded, color: Colors.white),
      gradientColors: [Colors.green.shade500, Colors.green.shade700],
      onTap: widget.onRestore, 
      borderRadius: 12,
    );
  }
}