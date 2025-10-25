import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/category/controller/category_controller.dart';
import 'package:ql_moifood_app/views/category/widgets/category_list_item.dart';

class CategoryView extends StatefulWidget {
  static const String routeName = '/category';
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late final CategoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CategoryController(context);
    Future.microtask(() => _controller.loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();

    return Scaffold(
      key: const PageStorageKey('category_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: categoryVM.isLoading && categoryVM.category.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : categoryVM.errorMessage != null &&
                        categoryVM.category.isEmpty
                    ? Center(child: Text('Lỗi: ${categoryVM.errorMessage}'))
                    : categoryVM.category.isEmpty
                        ? const Center(child: Text('Không có danh mục nào.'))
                        : RefreshIndicator(
                            onRefresh: _controller.loadCategories,
                            child: ListView.builder(
                              itemCount: categoryVM.category.length,
                              itemBuilder: (context, index) {
                                final category = categoryVM.category[index];
                                return CategoryListItem(
                                  key: ValueKey(category.categoryId),
                                  category: category,
                                  onEdit: () =>
                                      _controller.showEditCategoryModal(
                                          category),
                                  onDelete: () =>
                                      _controller.confirmDeleteCategory(
                                          category),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Danh mục',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Consumer<CategoryViewModel>(
            builder: (context, vm, _) => CustomButton(
              label: "Thêm mới",
              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              height: 48,
              fontSize: 14,
              gradientColors: AppColor.btnAdd,
              onTap: vm.isLoading ? null : _controller.showAddCategoryModal,
            ),
          ),
        ],
      ),
    );
  }
}
