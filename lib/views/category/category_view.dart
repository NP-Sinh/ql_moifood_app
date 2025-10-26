import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/category/controller/category_controller.dart';
import 'package:ql_moifood_app/views/category/widgets/category_empty.dart';
import 'package:ql_moifood_app/views/category/widgets/category_list_item.dart';

class CategoryView extends StatefulWidget {
  static const String routeName = '/category';
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with TickerProviderStateMixin {
  late final CategoryController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = CategoryController(context);
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
          // Header và TabBar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: _buildHeader(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Đang hoạt động'),
                        Tab(text: 'Đã xóa'),
                      ],
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      unselectedLabelColor: Colors.black54,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      splashBorderRadius: BorderRadius.circular(18),
                      dividerColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
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
    return Row(
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
          return CategoryEmpty(
            message: 'Không có danh mục nào.',
            onRefresh: _controller.loadCategories,
          );
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

  /// WIDGET CHO TAB 2
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
          return CategoryEmpty(
            message: 'Không có danh mục đã xóa.',
            icon: Icons.delete_outline,
            onRefresh: _controller.loadCategories,
          );
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
