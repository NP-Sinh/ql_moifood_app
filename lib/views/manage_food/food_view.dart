import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:ql_moifood_app/viewmodels/food_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/category/controller/category_controller.dart';
import 'package:ql_moifood_app/views/manage_food/controller/food_controller.dart';
import 'package:ql_moifood_app/views/manage_food/widgets/food_list_item.dart';
import 'package:ql_moifood_app/views/manage_food/widgets/food_empty.dart';

class FoodView extends StatefulWidget {
  static const String routeName = '/food';
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> with TickerProviderStateMixin {
  late final FoodController _controller;
  late final CategoryController _categoryController;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = FoodController(context);
    _categoryController = CategoryController(context);
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      _controller.loadFoods();
      _categoryController.loadCategories();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('food_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header và TabBar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: _buildHeader(),
                ),
                _buildTabBar(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableFoodsList(),
                _buildUnavailableFoodsList(),
                _buildDeletedFoodsList(),
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
          'Quản lý Món ăn',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 600,
          child: CustomTextField(
            controller: _searchController,
            isSearch: true,
            hintText: 'Tìm kiếm....',
            prefixIcon: Icons.search_rounded,
            onChanged: _controller.onSearchChanged,
            onClear: () {
              _controller.onSearchChanged('');
            },
          ),
        ),
        Consumer<FoodViewModel>(
          builder: (context, vm, _) => CustomButton(
            label: "Thêm món",
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            height: 48,
            fontSize: 14,
            gradientColors: AppColor.btnAdd,
            onTap: vm.isLoading ? null : _controller.showAddFoodModal,
          ),
        ),
      ],
    );
  }

  // build tab
  Widget _buildTabBar() {
    return Padding(
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
            Tab(text: 'Ngừng bán'),
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
            fontSize: 14,
          ),
          unselectedLabelColor: Colors.black54,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          dividerColor: Colors.transparent,
        ),
      ),
    );
  }

  // Tab 1: món ăn đang hoạt động
  Widget _buildAvailableFoodsList() {
    return Consumer<FoodViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.availableFoods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && vm.availableFoods.isEmpty) {
          return FoodEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadFoods,
          );
        }
        if (vm.availableFoods.isEmpty) {
          return FoodEmpty(
            message: 'Chưa có món ăn nào đang hoạt động.',
            icon: Icons.fastfood_rounded,
            onRefresh: _controller.loadFoods,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadFoods,
          child: ListView.builder(
            itemCount: vm.availableFoods.length,
            itemBuilder: (context, index) {
              final food = vm.availableFoods[index];
              return FoodListItem(
                key: ValueKey(food.foodId),
                food: food,
                isDeleted: false,
                isAvailable: true,
                onEdit: () => _controller.showEditFoodModal(food),
                onDelete: () => _controller.confirmDeleteFood(food),
                onToggleAvailable: () =>
                    _controller.confirmSetAvailableStatus(food, false),
              );
            },
          ),
        );
      },
    );
  }

  // Tab 2: món ăn ngừng bán
  Widget _buildUnavailableFoodsList() {
    return Consumer<FoodViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.unavailableFoods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && vm.unavailableFoods.isEmpty) {
          return FoodEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadFoods,
          );
        }
        if (vm.unavailableFoods.isEmpty) {
          return FoodEmpty(
            message: 'Không có món ăn nào ngừng bán.',
            icon: Icons.pause_circle_outline_rounded,
            onRefresh: _controller.loadFoods,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadFoods,
          child: ListView.builder(
            itemCount: vm.unavailableFoods.length,
            itemBuilder: (context, index) {
              final food = vm.unavailableFoods[index];
              return FoodListItem(
                key: ValueKey('unavailable_${food.foodId}'),
                food: food,
                isDeleted: false,
                isAvailable: false,
                onEdit: () => _controller.showEditFoodModal(food),
                onDelete: () => _controller.confirmDeleteFood(food),
                onToggleAvailable: () =>
                    _controller.confirmSetAvailableStatus(food, true),
              );
            },
          ),
        );
      },
    );
  }

  // Tab 3: danh sách món đã xóa
  Widget _buildDeletedFoodsList() {
    return Consumer<FoodViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.deletedFoods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && vm.deletedFoods.isEmpty) {
          return FoodEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadFoods,
          );
        }
        if (vm.deletedFoods.isEmpty) {
          return FoodEmpty(
            message: 'Không có món ăn nào đã xóa.',
            icon: Icons.delete_sweep_rounded,
            onRefresh: _controller.loadFoods,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadFoods,
          child: ListView.builder(
            itemCount: vm.deletedFoods.length,
            itemBuilder: (context, index) {
              final food = vm.deletedFoods[index];
              return FoodListItem(
                key: ValueKey('deleted_${food.foodId}'),
                food: food,
                isDeleted: true,
                onRestore: () => _controller.confirmRestoreFood(food),
              );
            },
          ),
        );
      },
    );
  }
}
