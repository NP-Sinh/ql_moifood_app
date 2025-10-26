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

// THÊM "with TickerProviderStateMixin"
class _CategoryViewState extends State<CategoryView>
    with TickerProviderStateMixin {
  late final CategoryController _controller;
  late final TabController _tabController; // THÊM

  @override
  void initState() {
    super.initState();
    _controller = CategoryController(context);
    // KHỞI TẠO TAB CONTROLLER VỚI 2 TAB
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _controller.loadCategories());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('category_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),
          // THÊM TABBAR
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đang hoạt động'),
                Tab(text: 'Đã xóa'),
              ],
              labelColor: AppColor.primary,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: AppColor.primary,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveCategoriesList(),
                _buildDeletedCategoriesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header
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
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
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

  /// WIDGET CHO TAB 1
  Widget _buildActiveCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryVM, _) {
        if (categoryVM.isLoading && categoryVM.category.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (categoryVM.errorMessage != null && categoryVM.category.isEmpty) {
          return Center(child: Text('Lỗi: ${categoryVM.errorMessage}'));
        }
        if (categoryVM.category.isEmpty) {
          return const Center(child: Text('Không có danh mục nào.'));
        }
        return RefreshIndicator(
          onRefresh: _controller.loadCategories,
          child: ListView.builder(
            itemCount: categoryVM.category.length,
            itemBuilder: (context, index) {
              final category = categoryVM.category[index];
              return CategoryListItem(
                key: ValueKey(category.categoryId),
                category: category,
                onEdit: () => _controller.showEditCategoryModal(category),
                onDelete: () => _controller.confirmDeleteCategory(category),
              );
            },
          ),
        );
      },
    );
  }

  /// WIDGET MỚI CHO TAB 2
  Widget _buildDeletedCategoriesList() {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryVM, _) {
        if (categoryVM.isLoading && categoryVM.deletedCategories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (categoryVM.errorMessage != null &&
            categoryVM.deletedCategories.isEmpty) {
          return Center(child: Text('Lỗi: ${categoryVM.errorMessage}'));
        }
        if (categoryVM.deletedCategories.isEmpty) {
          return const Center(child: Text('Không có danh mục đã xóa.'));
        }

        return RefreshIndicator(
          onRefresh: _controller.loadCategories,
          child: ListView.builder(
            itemCount: categoryVM.deletedCategories.length,
            itemBuilder: (context, index) {
              final category = categoryVM.deletedCategories[index];
              return CategoryListItem(
                key: ValueKey('deleted_${category.categoryId}'),
                category: category,
                isDeleted: true,
                onRestore: categoryVM.isLoading
                    ? null
                    : () {
                        _controller.confirmRestoreCategory(category);
                      },
              );
            },
          ),
        );
      },
    );
  }
}
