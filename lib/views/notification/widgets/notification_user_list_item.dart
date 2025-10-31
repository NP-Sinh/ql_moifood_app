import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class NotificationUserListItem extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const NotificationUserListItem({
    super.key,
    required this.notification,
    this.onView,
    this.onDelete,
  });

  @override
  State<NotificationUserListItem> createState() =>
      _NotificationUserListItemState();
}

class _NotificationUserListItemState extends State<NotificationUserListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: _buildDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              Expanded(child: _buildContent()),
              const SizedBox(width: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  //  DECORATION
  BoxDecoration _buildDecoration() => BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade50],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _isHovered
          ? AppColor.orange.withValues(alpha: 0.3)
          : Colors.grey.shade200,
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: _isHovered
            ? AppColor.orange.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        blurRadius: _isHovered ? 20 : 10,
        offset: Offset(0, _isHovered ? 8 : 4),
        spreadRadius: _isHovered ? 2 : 0,
      ),
    ],
  );

  //  ICON
  Widget _buildIcon() {
    final typeConfig = _getTypeConfig(widget.notification.notificationType);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: typeConfig['colors'] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _isHovered
                ? (typeConfig['colors'] as List<Color>)[0].withValues(
                    alpha: 0.3,
                  )
                : Colors.transparent,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        typeConfig['icon'] as IconData,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Map<String, dynamic> _getTypeConfig(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return {
          'icon': Icons.receipt_long_rounded,
          'colors': [Colors.green.shade400, Colors.green.shade600],
          'label': 'Đơn hàng',
          'color': Colors.green.shade600,
        };
      case 'promotion':
        return {
          'icon': Icons.sell_rounded,
          'colors': [Colors.orange.shade400, Colors.orange.shade600],
          'label': 'Khuyến mãi',
          'color': Colors.orange.shade600,
        };
      case 'error':
        return {
          'icon': Icons.fastfood_rounded,
          'colors': [Colors.red.shade400, Colors.red.shade600],
          'label': 'Món mới',
          'color': Colors.red.shade600,
        };
      case 'system':
      default:
        return {
          'icon': Icons.info_rounded,
          'colors': [Colors.blue.shade400, Colors.blue.shade600],
          'label': 'Hệ thống',
          'color': Colors.blue.shade600,
        };
    }
  }

  //  CONTENT
  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              widget.notification.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _buildTypeBadge(),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        widget.notification.message,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.5,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 4),
          Text(
            formatDateTime(widget.notification.createdAt),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 16),
          Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(
            'User: ${widget.notification.fullName}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    ],
  );

  Widget _buildTypeBadge() {
    final typeConfig = _getTypeConfig(widget.notification.notificationType);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (typeConfig['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (typeConfig['color'] as Color).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        typeConfig['label'] as String,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: typeConfig['color'] as Color,
        ),
      ),
    );
  }

  // ACTION BUTTONS
  Widget _buildActionButtons() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomButton(
        tooltip: "Xem chi tiết",
        width: 44,
        height: 44,
        iconSize: 22,
        icon: const Icon(Icons.visibility_rounded, color: Colors.white),
        gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
        onTap: widget.onView,
        borderRadius: 12,
      ),
      const SizedBox(width: 8),
      CustomButton(
        tooltip: "Xóa thông báo",
        width: 44,
        height: 44,
        iconSize: 22,
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        gradientColors: [Colors.redAccent.shade200, Colors.redAccent.shade400],
        onTap: widget.onDelete,
        borderRadius: 12,
      ),
    ],
  );
}
