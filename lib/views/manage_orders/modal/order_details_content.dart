import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/models/order_item.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';

class OrderDetailsContent extends StatelessWidget {
  final Order order;
  final Function(String newStatus)? onStatusChange;

  const OrderDetailsContent({
    super.key,
    required this.order,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return _buildDetailsView(order, context);
  }

  Widget _buildDetailsView(Order order, BuildContext context) {
    final address = order.deliveryAddress ?? 'Không có địa chỉ giao hàng';
    final note = order.note ?? 'Không có ghi chú';

    final paymentInfo = order.payments.isNotEmpty
        ? '${order.payments.first.methodName} - ${order.payments.first.paymentStatus}'
        : 'Chưa có thông tin thanh toán';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Status Card with Actions
          _buildStatusCard(order.orderStatus ?? 'N/A', context),
          const SizedBox(height: 16),

          // Customer Information Card
          _buildCard(
            title: 'Thông tin khách hàng',
            icon: Icons.person_outline,
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.badge_outlined,
                  'Mã khách hàng',
                  '#${order.userId}',
                ),
                const Divider(height: 16),
                _buildInfoRow(Icons.person, 'Tên khách hàng', order.fullName),
                const Divider(height: 16),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  'Địa chỉ',
                  address,
                  maxLines: 2,
                ),
                if (note != 'Không có ghi chú') ...[
                  const Divider(height: 16),
                  _buildInfoRow(
                    Icons.note_outlined,
                    'Ghi chú',
                    note,
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Payment Information Card
          _buildCard(
            title: 'Thông tin thanh toán',
            icon: Icons.payment_outlined,
            child: Column(
              children: [
                _buildInfoRow(Icons.credit_card, 'Phương thức', paymentInfo),
                const Divider(height: 16),
                _buildInfoRow(
                  Icons.access_time,
                  'Thời gian tạo',
                  formatDateTime(order.createdAt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Order Items Card
          _buildCard(
            title: 'Chi tiết món ăn',
            icon: Icons.restaurant_menu,
            child: _buildItemsList(order.orderItems),
          ),
          const SizedBox(height: 16),

          // Total Amount Card
          _buildTotalCard(order.totalAmount),
        ],
      ),
    );
  }

  // Status Card with color coding and action buttons
  Widget _buildStatusCard(String status, BuildContext context) {
    Color statusColor = OrderStatusHelper.getStatusColor(status);
    IconData statusIcon = OrderStatusHelper.getStatusIcon(status);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.1),
            statusColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái đơn hàng',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          if (onStatusChange != null && _canChangeStatus(status))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: _buildActionButtons(status, statusColor, context),
            ),
        ],
      ),
    );
  }

  // Check if status can be changed
  bool _canChangeStatus(String status) {
    return status != OrderStatus.completed && status != OrderStatus.cancelled;
  }

  // Build action buttons based on current status
  Widget _buildActionButtons(
    String status,
    Color statusColor,
    BuildContext context,
  ) {
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

  // Action button widget
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

  // Show confirmation dialog
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
            Text(title),
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

  // Generic Card Widget
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Card Body
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  // Info Row Widget
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Items List
  Widget _buildItemsList(List<OrderItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 48,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 8),
              Text(
                'Không có món ăn nào.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(height: 24, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final item = items[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.foodImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.foodName ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatVND(item.price)} × ${item.quantity}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  if (item.note != null && item.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.note,
                            size: 12,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              item.note!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade900,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Price
            Text(
              formatVND(item.price * item.quantity),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  // Total Card
  Widget _buildTotalCard(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent.shade100, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Thành tiền',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            formatVND(total),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
