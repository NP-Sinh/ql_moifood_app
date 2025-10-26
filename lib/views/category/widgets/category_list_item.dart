import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;
  final bool isDeleted;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;

  const CategoryListItem({
    super.key,
    required this.category,
    this.isDeleted = false,
    this.onEdit,
    this.onDelete,
    this.onRestore,
  });

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
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
    final List<Color> iconGradient = widget.isDeleted
        ? [Colors.grey.shade500, Colors.grey.shade600]
        : [AppColor.orange, AppColor.orange.withValues(alpha: 0.8)];
    final IconData iconData = widget.isDeleted
        ? Icons.delete_sweep_rounded
        : Icons.category_rounded;

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
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: hoverColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(iconData, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 16),

              // Thông tin category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tên category
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.isDeleted
                            ? Colors.black54
                            : Colors.black87,
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Mô tả
                    Text(
                      widget.category.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        decoration: widget.isDeleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        height: 1.3,
                      ),
                      maxLines: 2,
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

  /// Widget cho các nút Sửa và Xóa
  Widget _buildActiveButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button
        CustomButton(
          width: 44,
          height: 44,
          iconSize: 22,
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
          onTap: widget.onEdit,
          borderRadius: 12,
        ),
        const SizedBox(width: 8),

        // Delete button
        CustomButton(
          width: 44,
          height: 44,
          iconSize: 22,
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          gradientColors: [
            Colors.redAccent.shade200,
            Colors.redAccent.shade400,
          ],
          onTap: widget.onDelete,
          borderRadius: 12,
        ),
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
