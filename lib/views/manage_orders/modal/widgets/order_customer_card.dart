import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/info_card_wrapper.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/info_row.dart';

class OrderCustomerCard extends StatelessWidget {
  final Order order;

  const OrderCustomerCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final address = order.deliveryAddress ?? 'Không có địa chỉ giao hàng';
    final note = order.note ?? 'Không có ghi chú';

    return InfoCardWrapper(
      title: 'Thông tin khách hàng',
      icon: Icons.person_outline,
      child: Column(
        children: [
          InfoRow(
            icon: Icons.badge_outlined,
            label: 'Mã khách hàng',
            value: '#${order.userId}',
          ),
          const Divider(height: 16),
          InfoRow(
            icon: Icons.person,
            label: 'Tên khách hàng',
            value: order.fullName,
          ),
          const Divider(height: 16),
          InfoRow(
            icon: Icons.phone,
            label: 'Số điện thoại',
            value: order.phone ?? "Chưa có",
          ),
          const Divider(height: 16),
          InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Địa chỉ',
            value: address,
            maxLines: 2,
          ),
          if (note != 'Không có ghi chú') ...[
            const Divider(height: 16),
            InfoRow(
              icon: Icons.note_outlined,
              label: 'Ghi chú',
              value: note,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}