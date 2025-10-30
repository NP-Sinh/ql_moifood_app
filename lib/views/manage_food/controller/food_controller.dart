import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/food_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';

import 'package:ql_moifood_app/views/manage_food/modals/food_form.dart';

class FoodController {
  final BuildContext context;
  late final FoodViewModel _viewModel;
  Timer? _debounce;

  FoodController(this.context) {
    _viewModel = context.read<FoodViewModel>();
  }

  void dispose() {
    _debounce?.cancel();
  }

  // tải món ăn
  Future<void> loadFoods() async {
    await _viewModel.fetchFoods();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        'Lỗi tải món ăn: ${_viewModel.errorMessage}',
        type: SnackBarType.error,
      );
    }
  }

  // Xử lý search với debounce
  void onSearchChanged(String query) {
    searchFoods(query);
  }

  // Tìm kiếm food
  Future<void> searchFoods(String keyword) async {
    await _viewModel.searchFoods(keyword);
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // Hàm xử lý Bán / Ngừng bán
  void confirmSetAvailableStatus(Food food, bool isAvailable) {
    final actionText = isAvailable ? 'Mở bán' : 'Ngừng bán';
    final actionColor = isAvailable ? Colors.green : Colors.amber.shade700;

    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận $actionText',
      message: 'Bạn có chắc muốn $actionText món "${food.name}"?',
      confirmText: actionText,
      confirmColor: actionColor,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.setAvailableStatus(
          foodId: food.foodId,
          isAvailable: isAvailable,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? '$actionText món ${food.name} thành công'
                : _viewModel.errorMessage ?? 'Cập nhật thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }

  // Hiển thị modal Thêm / Sửa
  void _showModifyFoodModal({
    Food? food,
    required List<Category> allCategories,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: food?.name);
    final descriptionController = TextEditingController(
      text: food?.description,
    );
    final priceController = TextEditingController(
      text: food?.price.toStringAsFixed(0),
    );

    XFile? pickedImage;
    Category? selectedCategory;
    if (food != null) {
      try {
        selectedCategory = allCategories.firstWhere(
          (c) => c.categoryId == food.categoryId,
        );
      } catch (e) {
        selectedCategory = allCategories.isNotEmpty
            ? allCategories.first
            : null;
      }
    } else {
      selectedCategory = allCategories.isNotEmpty ? allCategories.first : null;
    }

    if (allCategories.isEmpty) {
      AppUtils.showSnackBar(
        context,
        'Cần tạo danh mục trước khi thêm món ăn!',
        type: SnackBarType.error,
      );
      return;
    }
    AppUtils.showBaseModal(
      context,
      title: food == null ? 'Thêm món ăn mới' : 'Cập nhật món ăn',
      child: FoodForm(
        formKey: formKey,
        food: food,
        nameController: nameController,
        descriptionController: descriptionController,
        priceController: priceController,
        categories: allCategories,
        initialCategory: selectedCategory,
        onImagePicked: (file) {
          pickedImage = file;
        },
        onCategoryChanged: (category) {
          selectedCategory = category;
        },
      ),
      secondaryAction: CustomButton(
        label: 'Hủy',
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
      ),
      primaryAction: Consumer<FoodViewModel>(
        builder: (context, vm, _) => CustomButton(
          label: food == null ? 'Thêm' : 'Cập nhật',
          gradientColors: AppColor.btnAdd,
          onTap: () async {
            if (formKey.currentState!.validate() && selectedCategory != null) {
              final success = await vm.modifyFood(
                id: food?.foodId ?? 0,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                price: double.tryParse(priceController.text) ?? 0.0,
                categoryId: selectedCategory!.categoryId,
                imageFile: pickedImage,
              );

              if (context.mounted) {
                Navigator.pop(context);
                AppUtils.showSnackBar(
                  context,
                  success
                      ? (food == null
                            ? 'Thêm thành công'
                            : 'Cập nhật thành công')
                      : vm.errorMessage ?? 'Thao tác thất bại',
                  type: success ? SnackBarType.success : SnackBarType.error,
                );
              }
            }
          },
        ),
      ),
    );
  }

  void showAddFoodModal() {
    final categories = context.read<CategoryViewModel>().category;
    _showModifyFoodModal(food: null, allCategories: categories);
  }

  void showEditFoodModal(Food food) {
    final categories = context.read<CategoryViewModel>().category;
    _showModifyFoodModal(food: food, allCategories: categories);
  }

  // Xác nhận xóa
  void confirmDeleteFood(Food food) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa món "${food.name}" không?',
      confirmText: 'Xóa',
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.deleteFood(foodId: food.foodId);
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã xóa món ${food.name}'
                : _viewModel.errorMessage ?? 'Xóa thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }

  // Xác nhận khôi phục
  void confirmRestoreFood(Food food) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận khôi phục',
      message: 'Bạn có chắc muốn khôi phục món "${food.name}" không?',
      confirmText: 'Khôi phục',
      confirmColor: Colors.green,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.restoreFood(foodId: food.foodId);
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã khôi phục ${food.name}'
                : _viewModel.errorMessage ?? 'Khôi phục thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }
}
