import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';

class OrderCardActions extends StatelessWidget {
  final String status;
  final VoidCallback? onViewDetails;
  final Function(String newStatus)? onStatusChange;

  const OrderCardActions({
    super.key,
    required this.status,
    this.onViewDetails,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    // Nút xem chi tiết
    buttons.add(
      CustomButton(
        tooltip: 'Xem chi tiết',
        icon: Icon(
          Icons.visibility_outlined,
          color: Colors.grey.shade600,
          size: 20,
        ),
        onTap: onViewDetails,
        width: 44,
        height: 44,
        iconSize: 20,
        borderRadius: 12,
        gradientColors: [Colors.grey.shade200, Colors.grey.shade100],
        showShadow: false,
      ),
    );

    // Nút thay đổi trạng thái
    if (onStatusChange != null &&
        status != OrderStatus.completed &&
        status != OrderStatus.cancelled) {
      buttons.add(const SizedBox(width: 8));
      buttons.add(
        CustomButton(
          tooltip: 'Thay đổi trạng thái',
          icon: Icon(
            Icons.swap_horiz_rounded,
            color: AppColor.orange,
            size: 20,
          ),
          onTap: () => _showStatusChangeMenu(context, status),
          width: 44,
          height: 44,
          iconSize: 20,
          borderRadius: 12,
          gradientColors: [
            AppColor.orange.withValues(alpha: 0.1),
            AppColor.orange.withValues(alpha: 0.05),
          ],
          showShadow: false,
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  void _showStatusChangeMenu(BuildContext context, String currentStatus) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        // Confirmed option
        if (currentStatus != OrderStatus.confirmed)
          _buildStatusMenuItem(
            OrderStatus.confirmed,
            'Đã xác nhận',
            Icons.hourglass_top_rounded,
            Colors.blue.shade600,
          ),
        // Completed option
        if (currentStatus != OrderStatus.completed)
          _buildStatusMenuItem(
            OrderStatus.completed,
            'Đã hoàn thành',
            Icons.check_circle_outline_rounded,
            Colors.green.shade600,
          ),
        // Cancelled option
        if (currentStatus != OrderStatus.cancelled)
          _buildStatusMenuItem(
            OrderStatus.cancelled,
            'Đã hủy',
            Icons.cancel_outlined,
            Colors.red.shade600,
          ),
      ],
    ).then((newStatus) {
      if (newStatus != null && newStatus != currentStatus) {
        if (onStatusChange != null) {
          onStatusChange!(newStatus);
        }
      }
    });
  }

  PopupMenuItem<String> _buildStatusMenuItem(
    String status,
    String label,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: status,
      height: 48,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}