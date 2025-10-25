import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const CategoryForm({
    super.key,
    this.category,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      widget.nameController.text = widget.category!.name;
      widget.descriptionController.text = widget.category!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: widget.nameController,
            labelText: "Tên danh mục",
            hintText: "Nhập tên danh mục (ví dụ: Cà phê)",
            prefixIcon: Icons.category_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tên danh mục không được để trống';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.descriptionController,
            labelText: "Mô tả (Không bắt buộc)",
            hintText: "Nhập mô tả ngắn...",
            prefixIcon: Icons.description_rounded,
          ),
        ],
      ),
    );
  }
}
