import 'package:flutter/material.dart';
import 'package:ql_moifood_app/views/category/category_view.dart';
import 'package:ql_moifood_app/views/Dashboard/widgets/sidebar_menu.dart';
import 'package:ql_moifood_app/views/Dashboard/widgets/top_bar.dart';
import 'package:ql_moifood_app/views/customer/user_view.dart';
import 'package:ql_moifood_app/views/dashboard/overview_content.dart';
import 'package:ql_moifood_app/views/manage_food/food_view.dart';
import 'package:ql_moifood_app/views/manage_orders/order_view.dart';
import 'package:ql_moifood_app/views/notification/notification_view.dart';
import 'package:ql_moifood_app/views/payment/payment_view.dart';
import 'package:ql_moifood_app/views/reports/statistic_view.dart';
import 'package:ql_moifood_app/views/review/review_view.dart';
import 'package:ql_moifood_app/views/settings/setting_view.dart';

class DashboardView extends StatefulWidget {
  static const String routeName = '/DashboardView';
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Tổng quan'},
    {'icon': Icons.shopping_bag_rounded, 'label': 'Đơn hàng'},
    {'icon': Icons.category_rounded, 'label': 'Danh mục'},
    {'icon': Icons.restaurant_menu_rounded, 'label': 'Món ăn'},
    {'icon': Icons.people_rounded, 'label': 'Khách hàng'},
    {'icon': Icons.analytics_rounded, 'label': 'Thống kê'},
    {'icon': Icons.rate_review, 'label': 'Đánh giá'},
    {'icon': Icons.edit_notifications, 'label': 'Thông báo'},
    {'icon': Icons.payment, 'label': 'Thanh toán'},
    {'icon': Icons.settings_rounded, 'label': 'Cài đặt'},
  ];

  Widget _buildMainContent(bool isDesktop, bool isTablet) {
    switch (_selectedIndex) {
      case 0:
        return OverviewContent(isDesktop: isDesktop, isTablet: isTablet);
      case 1:
        return const OrderView();
      case 2:
        return const CategoryView();
      case 3:
        return const FoodView();
      case 4:
        return const UserView();
      case 5:
        return const StatisticView();
      case 6:
        return const ReviewView();
      case 7:
        return const NotificationView();
      case 8:
        return const PaymentView();
      case 9:
        return const SettingsView();
      default:
        return OverviewContent(isDesktop: isDesktop, isTablet: isTablet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 800 && size.width <= 1200;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          //Sidebar
          SidebarMenu(
            isDesktop: isDesktop,
            isTablet: isTablet,
            menuItems: _menuItems,
            selectedIndex: _selectedIndex,
            onMenuItemTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                //Topbar
                const TopBar(),
                // Nội dung chính
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildMainContent(isDesktop, isTablet),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
