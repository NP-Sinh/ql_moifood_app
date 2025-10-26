import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/resources/utils/app_utils.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/views/category/modals/category_form.dart';

class CategoryController {
  final BuildContext context;

  CategoryController(this.context);

  /// Tải danh mục
  Future<void> loadCategories() async {
    final categoryVM = Provider.of<CategoryViewModel>(context, listen: false);
    await categoryVM.fetchCategories();

    if (categoryVM.errorMessage != null) {
      AppUtils.showSnackBar(
        context,
        'Lỗi tải danh mục: ${categoryVM.errorMessage}',
        type: SnackBarType.error,
      );
    }
  }

  /// Hiển thị modal thêm danh mục
  void showAddCategoryModal() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    AppUtils.showBaseModal<bool>(
      context,
      title: "Tạo danh mục mới",
      child: CategoryForm(
        formKey: formKey,
        nameController: nameController,
        descriptionController: descriptionController,
      ),
      secondaryAction: CustomButton(
        label: "Hủy",
        height: 48,
        fontSize: 14,
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      primaryAction: Consumer<CategoryViewModel>(
        builder: (context, categoryVM, _) => CustomButton(
          label: categoryVM.isLoading ? "Đang tạo..." : "Tạo mới",
          icon: categoryVM.isLoading
              ? Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add_rounded, color: Colors.white, size: 18),
          gradientColors: AppColor.btnAdd,
          height: 48,
          fontSize: 14,
          onTap: categoryVM.isLoading
              ? null
              : () async {
                  if (formKey.currentState?.validate() == true) {
                    final success = await categoryVM.addCategory(
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context, success);
                      if (success) {
                        AppUtils.showSnackBar(
                          context,
                          'Tạo danh mục mới thành công',
                          type: SnackBarType.success,
                        );
                      } else {
                        AppUtils.showSnackBar(
                          context,
                          categoryVM.errorMessage ?? 'Tạo mới thất bại',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  }
                },
        ),
      ),
    );
  }

  /// Hiển thị modal sửa danh mục
  void showEditCategoryModal(Category category) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category.name);
    final descriptionController = TextEditingController(
      text: category.description,
    );

    AppUtils.showBaseModal<bool>(
      context,
      title: "Sửa danh mục",
      child: CategoryForm(
        category: category,
        formKey: formKey,
        nameController: nameController,
        descriptionController: descriptionController,
      ),
      secondaryAction: CustomButton(
        label: "Hủy",
        height: 48,
        fontSize: 14,
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      primaryAction: Consumer<CategoryViewModel>(
        builder: (context, categoryVM, _) => CustomButton(
          label: categoryVM.isLoading ? "Đang lưu..." : "Lưu thay đổi",
          icon: categoryVM.isLoading
              ? Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_rounded, color: Colors.white, size: 18),
          gradientColors: AppColor.btnAdd,
          height: 48,
          fontSize: 14,
          onTap: categoryVM.isLoading
              ? null
              : () async {
                  if (formKey.currentState?.validate() == true) {
                    final success = await categoryVM.updateCategory(
                      categoryId: category.categoryId,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      AppUtils.showSnackBar(
                        context,
                        success
                            ? 'Cập nhật danh mục thành công'
                            : categoryVM.errorMessage ?? 'Cập nhật thất bại',
                        type: success
                            ? SnackBarType.success
                            : SnackBarType.error,
                      );
                    }
                  }
                },
        ),
      ),
    );
  }

  /// Hiển thị xác nhận xóa danh mục
  void confirmDeleteCategory(Category category) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa danh mục "${category.name}" không?',
      confirmText: 'Xóa',
      confirmColor: Colors.redAccent,
    ).then((confirmed) async {
      if (confirmed == true) {
        final categoryVM = Provider.of<CategoryViewModel>(
          context,
          listen: false,
        );
        final success = await categoryVM.deleteCategory(
          categoryId: category.categoryId,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã xóa danh mục ${category.name}'
                : categoryVM.errorMessage ?? 'Xóa thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }
}
