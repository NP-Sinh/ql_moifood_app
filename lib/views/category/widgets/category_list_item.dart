import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColor.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.category_rounded,
                size: 30,
                color: AppColor.orange,
              ),
            ),
            const SizedBox(width: 16),

            // Tên
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CustomButton(
              width: 44,
              height: 44,
              iconSize: 22,
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
              onTap: onEdit,
            ),

            const SizedBox(width: 8),
            CustomButton(
              width: 44,
              height: 44,
              iconSize: 22,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
              gradientColors: [
                Colors.redAccent.shade200,
                Colors.redAccent.shade400,
              ],
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
