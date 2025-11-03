import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/views/auth/login_view.dart';
import 'package:ql_moifood_app/views/chat/chatbot_modal_content.dart';
import 'package:ql_moifood_app/views/customer/controller/user_controller.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late final UserController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = UserController(context);
    Future.microtask(() {
      _controller.loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận đăng xuất',
      message: 'Bạn có chắc muốn đăng xuất khỏi hệ thống?',
      confirmText: 'Đăng xuất',
      cancelText: 'Hủy',
      confirmColor: Colors.redAccent,
    );

    if (shouldLogout == true) {
      await AuthStorage.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginView.routeName,
          (route) => false,
        );
      }
    }
  }

  void _showChatBotView(BuildContext context) {
    // Sử dụng showDialog chuẩn của Flutter
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Trả về widget Dialog riêng của chúng ta
        return const ChatbotDialog();
      },
    );
  }

  // Xử lý khi bấm Thông báo
  void _handleNotificationTap(BuildContext context) {
    // TODO: Thêm logic mở bảng thông báo tại đây
    debugPrint("Notification button tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔍 Search Bar
          // Expanded(
          //   child: CustomTextField(
          //     controller: _searchController,
          //     isSearch: true,
          //     hintText: 'Tìm kiếm...',
          //     prefixIcon: Icons.search_rounded,
          //     labelPosition: LabelPosition.none,
          //     onChanged: _onSearchChanged,
          //     onClear: () {
          //       _onSearchChanged('');
          //     },
          //   ),
          // ),
          const Spacer(),

          const SizedBox(width: 16),

          // Notification Icon
          CustomButton(
            onTap: () => _handleNotificationTap(context),
            icon: Icon(
              Icons.notifications_rounded,
              color: Colors.grey.shade600,
              size: 20,
            ),
            width: 48,
            height: 48,
            gradientColors: [Colors.grey.shade100, Colors.grey.shade100],
            borderRadius: 12,
            showShadow: false,
            size: 0,
            iconSize: 48,
          ),

          const SizedBox(width: 16),

          // Chat Bot Icon
          CustomButton(
            onTap: () => _showChatBotView(context),
            tooltip: 'Chat Bot AI',
            icon: Image.asset(
              'assets/icons/generative.png',
              color: Colors.white,
              width: 32,
              height: 32,
            ),
            width: 48,
            height: 48,
            gradientColors: [
              Colors.indigoAccent.shade200,
              Colors.indigo.shade400,
            ],
            borderRadius: 12,
            showShadow: false,
            size: 0,
            iconSize: 48,
          ),

          const SizedBox(width: 16),

          // Logout Button
          CustomButton(
            tooltip: 'Đăng xuất',
            onTap: () => _handleLogout(context),
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 20,
            ),
            height: 48,
            width: 48,
            gradientColors: [
              Colors.redAccent.shade200,
              Colors.redAccent.shade400,
            ],
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}
