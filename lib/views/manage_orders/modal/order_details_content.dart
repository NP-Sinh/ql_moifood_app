import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/models/order_item.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
class OrderDetailsContent extends StatelessWidget {
  final Order order;

  const OrderDetailsContent({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final customerInfo = 'Khách hàng ID: ${order.userId}'; 
    final address = order.deliveryAddress ?? 'Không có địa chỉ giao hàng';
    final note = order.note ?? 'Không có ghi chú';
    final paymentInfo = order.payments.isNotEmpty
        ? '${order.payments.first.methodName} - ${order.payments.first.paymentStatus}'
        : 'Chưa có thông tin thanh toán';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection('Thông tin đơn hàng', [
          customerInfo,
          'Địa chỉ: $address',
          'Ghi chú: $note',
          'Thanh toán: $paymentInfo',
          'Trạng thái: ${order.orderStatus ?? 'N/A'}',
          'Tạo lúc: ${formatDateTime(order.createdAt)}',
        ]),
        const Divider(height: 24),
        _buildItemsSection('Chi tiết món ăn', order.orderItems),
        const Divider(height: 24),
        _buildTotalSection('Tổng cộng', order.totalAmount),
      ],
    );
  }
  Widget _buildInfoSection(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...details.map((text) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(text, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
        )),
      ],
    );
  }

  // Helper xây dựng section danh sách món
  Widget _buildItemsSection(String title, List<OrderItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Text('Không có món ăn nào.', style: TextStyle(color: Colors.grey))
        else
          ListView.separated(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  // Ảnh nhỏ
                  ClipRRect(
                     borderRadius: BorderRadius.circular(6),
                     child: Image.network(item.foodImageUrl, width: 40, height: 40, fit: BoxFit.cover,
                       errorBuilder: (_, __, ___) => Container(width: 40, height: 40, color: Colors.grey.shade200),
                     ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.foodName ?? 'N/A'} (x${item.quantity})', style: const TextStyle(fontWeight: FontWeight.w500)),
                         if(item.note != null && item.note!.isNotEmpty)
                           Text('Ghi chú: ${item.note}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(formatVND(item.price * item.quantity)),
                ],
              );
            },
          ),
      ],
    );
  }
   Widget _buildTotalSection(String title, double total) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
         Text(
           formatVND(total),
           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
         ),
       ],
     );
   }
}