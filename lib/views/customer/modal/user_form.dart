import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class UserForm extends StatelessWidget {
  final User user;

  const UserForm({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Icon mặc định nếu Avatar bị null hoặc lỗi
    final circleAvatar = CircleAvatar(
      radius: 48,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: (user.avatar != null && user.avatar!.isNotEmpty)
          ? NetworkImage(user.avatar!)
          : null,
      child: (user.avatar == null || user.avatar!.isEmpty)
          ? Icon(
              Icons.person_rounded,
              size: 48,
              color: Colors.grey.shade500,
            )
          : null,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột Avatar và Status
          SizedBox(
            width: 120,
            child: Column(
              children: [
                circleAvatar,
                const SizedBox(height: 16),
                _buildStatusChip(user.isActive),
                const SizedBox(height: 8),
                _buildRoleChip(user.role),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Cột thông tin chi tiết
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoTile(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  value: user.email,
                  isPrimary: true,
                ),
                _buildInfoTile(
                  icon: Icons.phone_rounded,
                  label: 'Số điện thoại',
                  value: user.phone ?? 'Chưa cập nhật',
                ),
                _buildInfoTile(
                  icon: Icons.location_on_rounded,
                  label: 'Địa chỉ',
                  value: user.address ?? 'Chưa cập nhật',
                ),
                _buildInfoTile(
                  icon: Icons.person_pin_rounded,
                  label: 'Mã người dùng',
                  value: 'ID: ${user.userId}',
                ),
                _buildInfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Ngày tham gia',
                  value: formatDateTime(user.createdAt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho các dòng thông tin
  Widget _buildInfoTile(
      {required IconData icon,
      required String label,
      required String value,
      bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
                    color: isPrimary ? AppColor.primary : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Chip cho Role
  Widget _buildRoleChip(String role) {
    final bool isAdmin = role.toLowerCase() == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColor.orange.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAdmin ? 'Quản trị viên' : 'Khách hàng',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: isAdmin ? AppColor.orange : Colors.blue.shade700,
        ),
      ),
    );
  }

  // Chip cho Status
  Widget _buildStatusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Đang hoạt động' : 'Bị vô hiệu hóa',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }
}