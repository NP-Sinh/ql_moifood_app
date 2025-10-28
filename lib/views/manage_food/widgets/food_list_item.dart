import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'food_card.dart'; 

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: FoodCard(
          food: widget.food,
          isDeleted: widget.isDeleted,
          isAvailable: widget.isAvailable,
          isHovered: _isHovered,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onRestore: widget.onRestore,
          onToggleAvailable: widget.onToggleAvailable,
        ),
      ),
    );
  }
}