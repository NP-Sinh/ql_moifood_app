import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class NotificationDetailForm extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailForm({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột Icon và Badges
          SizedBox(
            width: 120,
            child: Column(
              children: [
                _buildIcon(),
                const SizedBox(height: 16),
                _buildTypeBadge(),
                if (notification.isGlobal) ...[
                  const SizedBox(height: 8),
                  _buildGlobalBadge(),
                ],
                if (!notification.isGlobal && notification.isRead != null) ...[
                  const SizedBox(height: 8),
                  _buildReadBadge(notification.isRead!),
                ],
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
                  notification.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (!notification.isGlobal)
                  _buildInfoTile(
                    icon: Icons.person_rounded,
                    label: 'Người nhận',
                    value: 'User #${notification.userId}',
                    isPrimary: true,
                  ),
                _buildInfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Thời gian tạo',
                  value: formatDateTime(notification.createdAt),
                ),
                _buildInfoTile(
                  icon: Icons.fingerprint_rounded,
                  label: 'Mã thông báo',
                  value: '#${notification.notificationId}',
                ),
                const SizedBox(height: 16),
                _buildMessageSection(notification.message),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ICON 
  Widget _buildIcon() {
    final typeConfig = _getTypeConfig(notification.notificationType);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: typeConfig['colors'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (typeConfig['colors'] as List<Color>)[0]
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        typeConfig['icon'] as IconData,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Map<String, dynamic> _getTypeConfig(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return {
          'icon': Icons.check_circle_rounded,
          'colors': [Colors.green.shade400, Colors.green.shade600],
          'label': 'Thành công',
          'color': Colors.green.shade600,
        };
      case 'warning':
        return {
          'icon': Icons.warning_rounded,
          'colors': [Colors.orange.shade400, Colors.orange.shade600],
          'label': 'Cảnh báo',
          'color': Colors.orange.shade600,
        };
      case 'error':
        return {
          'icon': Icons.error_rounded,
          'colors': [Colors.red.shade400, Colors.red.shade600],
          'label': 'Lỗi',
          'color': Colors.red.shade600,
        };
      default: // info
        return {
          'icon': Icons.info_rounded,
          'colors': [Colors.blue.shade400, Colors.blue.shade600],
          'label': 'Thông tin',
          'color': Colors.blue.shade600,
        };
    }
  }

  //  BADGES 
  Widget _buildTypeBadge() {
    final typeConfig = _getTypeConfig(notification.notificationType);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (typeConfig['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (typeConfig['color'] as Color).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        typeConfig['label'] as String,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: typeConfig['color'] as Color,
        ),
      ),
    );
  }

  Widget _buildGlobalBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.public_rounded, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'Toàn hệ thống',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _buildReadBadge(bool isRead) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRead
                ? Colors.green.withValues(alpha: 0.4)
                : Colors.orange.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          isRead ? 'Đã đọc' : 'Chưa đọc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isRead ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
      );

  //  INFO TILE 
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
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

  //  MESSAGE SECTION
  Widget _buildMessageSection(String message) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message_rounded,
                  color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 8),
              Text(
                'Nội dung',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
          ),
        ],
      );
}