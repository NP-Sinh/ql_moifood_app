import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/customer/controller/user_controller.dart';
import 'package:ql_moifood_app/views/customer/widgets/user_empty.dart';
import 'package:ql_moifood_app/views/customer/widgets/user_list_item.dart';

class UserView extends StatefulWidget {
  static const String routeName = '/user';
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with TickerProviderStateMixin {
  late final UserController _controller;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = UserController(context);
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      _controller.loadUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    _controller.searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('user_view'),
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
                  child: buildHeader(),
                ),
                buildTabBar(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [buildTab1(), buildTab2()],
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quản lý Người dùng',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // Thanh tìm kiếm
        SizedBox(
          width: 500,
          child: CustomTextField(
            controller: _searchController,
            isSearch: true,
            hintText: 'Tìm theo tên, email, SĐT...',
            prefixIcon: Icons.search_rounded,
            onChanged: onSearchChanged,
            onClear: () {
              onSearchChanged('');
            },
          ),
        ),
      ],
    );
  }

  // build tab
  Widget buildTabBar() {
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
            Tab(text: 'Bị vô hiệu hóa'),
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

  // Tab 1:
  Widget buildTab1() {
    return Consumer<UserViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.activeUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && vm.activeUsers.isEmpty) {
          return UserEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadUsers,
          );
        }
        if (vm.activeUsers.isEmpty) {
          return UserEmpty(
            message: 'Không có người dùng nào đang hoạt động.',
            icon: Icons.people_outline_rounded,
            onRefresh: _controller.loadUsers,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadUsers,
          child: ListView.builder(
            itemCount: vm.activeUsers.length,
            itemBuilder: (context, index) {
              final user = vm.activeUsers[index];
              return UserListItem(
                key: ValueKey(user.userId),
                user: user,
                isActive: true,
                onView: () => _controller.showViewUserModal(user),
                onToggleActive: () => _controller.confirmSetActive(user, false),
              );
            },
          ),
        );
      },
    );
  }

  // Tab 2:
  Widget buildTab2() {
    return Consumer<UserViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.inactiveUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && vm.inactiveUsers.isEmpty) {
          return UserEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadUsers,
          );
        }
        if (vm.inactiveUsers.isEmpty) {
          return UserEmpty(
            message: 'Không có người dùng nào bị vô hiệu hóa.',
            icon: Icons.person_off_outlined,
            onRefresh: _controller.loadUsers,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadUsers,
          child: ListView.builder(
            itemCount: vm.inactiveUsers.length,
            itemBuilder: (context, index) {
              final user = vm.inactiveUsers[index];
              return UserListItem(
                key: ValueKey('inactive_${user.userId}'),
                user: user,
                isActive: false,
                onView: () => _controller.showViewUserModal(user),
                onToggleActive: () => _controller.confirmSetActive(user, true),
              );
            },
          ),
        );
      },
    );
  }
}
