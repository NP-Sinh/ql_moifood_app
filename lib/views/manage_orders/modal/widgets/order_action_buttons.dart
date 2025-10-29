import 'package:flutter/material.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';

class OrderActionButtons extends StatelessWidget {
  final String status;
  final Function(String newStatus)? onStatusChange;

  const OrderActionButtons({
    super.key,
    required this.status,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    switch (status) {
      case OrderStatus.pending:
        buttons.add(
          Expanded(
            child: _buildActionButton(
              label: 'Xác nhận đơn',
              icon: Icons.check_circle_outline,
              color: Colors.blue,
              onTap: () => _showConfirmDialog(
                context,
                'Xác nhận đơn hàng',
                'Bạn có chắc muốn xác nhận đơn hàng này?',
                OrderStatus.confirmed,
              ),
            ),
          ),
        );
        buttons.add(const SizedBox(width: 8));
        buttons.add(
          Expanded(
            child: _buildActionButton(
              label: 'Hủy đơn',
              icon: Icons.cancel_outlined,
              color: Colors.red,
              onTap: () => _showConfirmDialog(
                context,
                'Hủy đơn hàng',
                'Bạn có chắc muốn hủy đơn hàng này?',
                OrderStatus.cancelled,
              ),
            ),
          ),
        );
        break;

      case OrderStatus.confirmed:
        buttons.add(
          Expanded(
            child: _buildActionButton(
              label: 'Hoàn thành',
              icon: Icons.check_circle,
              color: Colors.green,
              onTap: () => _showConfirmDialog(
                context,
                'Hoàn thành đơn hàng',
                'Xác nhận đơn hàng đã được giao thành công?',
                OrderStatus.completed,
              ),
            ),
          ),
        );
        buttons.add(const SizedBox(width: 8));
        buttons.add(
          Expanded(
            child: _buildActionButton(
              label: 'Hủy đơn',
              icon: Icons.cancel_outlined,
              color: Colors.red,
              onTap: () => _showConfirmDialog(
                context,
                'Hủy đơn hàng',
                'Bạn có chắc muốn hủy đơn hàng này?',
                OrderStatus.cancelled,
              ),
            ),
          ),
        );
        break;
    }

    return Row(children: buttons);
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    String newStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onStatusChange != null) {
                onStatusChange!(newStatus);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}