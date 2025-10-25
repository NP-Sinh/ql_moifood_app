import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/category.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/resources/utils/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/category/modals/category_form.dart';
import 'package:ql_moifood_app/views/category/widgets/category_list_item.dart';

class CategoryView extends StatefulWidget {
  static const String routeName = '/category';
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  void _onEditCategory(Category category) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    AppUtils.showBaseModal(
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
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      primaryAction: CustomButton(
        label: "Lưu",
        height: 48,
        icon: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
        gradientColors: AppColor.btnAdd,
        onTap: () {
          if (formKey.currentState?.validate() == true) {
            // TODO: Gọi ViewModel để cập nhật
            // categoryVM.updateCategory(
            //   category.categoryId,
            //   nameController.text,
            //   descriptionController.text,
            // );
            Navigator.pop(context); // Đóng modal
            AppUtils.showSnackBar(context, 'Cập nhật thành công');
          }
        },
      ),
    );
  }

  // Hàm xử lý khi bấm Thêm Mới
  void _onAddNewCategory() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    AppUtils.showBaseModal(
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
        onTap: () => Navigator.pop(context),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),

      primaryAction: CustomButton(
        label: "Lưu",
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
        height: 48,
        gradientColors: AppColor.btnAdd,
        onTap: () {
          if (formKey.currentState?.validate() == true) {
            // TODO: Gọi ViewModel để thêm mới
            // categoryVM.addCategory(
            //   nameController.text,
            //   descriptionController.text,
            // );
            Navigator.pop(context); // Đóng modal
            AppUtils.showSnackBar(context, 'Tạo mới thành công');
          }
        },
      ),
    );
  }

  // Hàm xử lý khi bấm Xóa
  void _onDeleteCategory(Category category) {
    debugPrint('Delete: ${category.name}');

    // Hiển thị dialog xác nhận
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa danh mục "${category.name}" không?',
      confirmText: 'Xóa',
      confirmColor: Colors.redAccent,
    ).then((confirmed) {
      if (confirmed == true) {
        // TODO: Gọi ViewModel để xóa
        // Provider.of<CategoryViewModel>(context, listen: false)
        //     .deleteCategory(category.categoryId);

        AppUtils.showSnackBar(
          context,
          'Đã xóa danh mục ${category.name}',
          type: SnackBarType.success,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();

    return Scaffold(
      key: PageStorageKey('category_page'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: categoryVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : categoryVM.category.isEmpty
                ? const Center(child: Text('Không có danh mục nào.'))
                : ListView.builder(
                    itemCount: categoryVM.category.length,
                    itemBuilder: (context, index) {
                      final category = categoryVM.category[index];
                      return CategoryListItem(
                        category: category,
                        onEdit: () => _onEditCategory(category),
                        onDelete: () => _onDeleteCategory(category),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget cho thanh Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Danh mục',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          CustomButton(
            label: "Thêm mới",
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            height: 48,
            fontSize: 14,
            gradientColors: AppColor.btnAdd,
            onTap: _onAddNewCategory,
          ),
        ],
      ),
    );
  }
}
