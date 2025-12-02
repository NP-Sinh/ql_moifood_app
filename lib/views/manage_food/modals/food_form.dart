import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class FoodForm extends StatefulWidget {
  final Food? food;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final List<Category> categories;
  final Category? initialCategory;
  final ValueChanged<XFile?> onImagePicked;
  final ValueChanged<Category?> onCategoryChanged;

  const FoodForm({
    super.key,
    this.food,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.categories,
    required this.initialCategory,
    required this.onImagePicked,
    required this.onCategoryChanged,
  });

  @override
  State<FoodForm> createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  XFile? _pickedImage;
  Category? _selectedCategory;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    if (widget.food != null) {
      widget.nameController.text = widget.food!.name;
      widget.descriptionController.text = widget.food!.description;
      widget.priceController.text = widget.food!.price.toStringAsFixed(0);
      try {
        _selectedCategory = widget.categories.firstWhere(
          (c) => c.categoryId == widget.food!.categoryId,
        );
      } catch (e) {
        _selectedCategory = widget.categories.isNotEmpty
            ? widget.categories.first
            : null;
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _imageBytes = bytes;
      });
      widget.onImagePicked(_pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: widget.nameController,
                  labelText: "Tên món ăn",
                  hintText: "Nhập tên món ăn",
                  prefixIcon: Icons.fastfood_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Tên món ăn không được để trống';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: widget.descriptionController,
                  labelText: "Mô tả",
                  hintText: "Nhập mô tả cho món ăn (tối đa 2 dòng)",
                  prefixIcon: Icons.description_rounded,
                  maxLines: 2,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        controller: widget.priceController,
                        labelText: "Giá (VNĐ)",
                        hintText: "Nhập giá bán",
                        prefixIcon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Giá không được để trống';
                          }
                          final price = double.tryParse(value);
                          if (price == null) {
                            return 'Giá không hợp lệ';
                          }
                          if (price <= 0) {
                            return 'Giá phải lớn hơn 0';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4.0,
                              bottom: 6.0,
                              top: 4.0,
                            ),
                            child: Text(
                              "Danh mục",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<Category>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.category_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              hintText: 'Chọn danh mục',
                            ),
                            items: widget.categories.map((Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (Category? newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                              widget.onCategoryChanged(newValue);
                            },
                            validator: (value) =>
                                value == null ? 'Vui lòng chọn' : null,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    bottom: 6.0,
                    top: 4.0,
                  ),
                  child: Text(
                    "Ảnh đại diện",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildImagePicker(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    String? existingImageUrl = widget.food?.imageUrl;

    return GestureDetector(
      onTap: _pickImage,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: DottedBorder(
          options: RectDottedBorderOptions(
            color: Colors.grey.shade400,
            strokeWidth: 2,
            dashPattern: const [6, 6],
            borderPadding: EdgeInsets.zero,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: (_pickedImage != null)
                ? _buildImageDisplay(
                    // Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                    Image.memory(_imageBytes!, fit: BoxFit.cover),
                  )
                : (existingImageUrl != null && existingImageUrl.isNotEmpty)
                ? _buildImageDisplay(
                    Image.network(existingImageUrl, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_rounded,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Chọn ảnh (Bỏ trống nếu giữ ảnh cũ)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(Image imageProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          imageProvider,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1.0],
              ),
            ),
          ),
          const Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              'Bấm để thay đổi ảnh',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
