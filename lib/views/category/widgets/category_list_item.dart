import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'category_card.dart';

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: CategoryCard(
          category: widget.category,
          isDeleted: widget.isDeleted,
          isHovered: _isHovered, 
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onRestore: widget.onRestore,
        ),
      ),
    );
  }
}