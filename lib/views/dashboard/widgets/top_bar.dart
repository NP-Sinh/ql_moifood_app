import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/views/auth/login_view.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

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
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

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
            // Đặt màu nền xám giống container gốc
            gradientColors: [Colors.grey.shade100, Colors.grey.shade100],
            borderRadius: 12,
            // Tắt bóng đổ
            showShadow: false,
            // Tinh chỉnh để Stack/icon lấp đầy 48x48
            size: 0,
            iconSize: 48,
          ),

          const SizedBox(width: 16),
          CustomButton(
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
