import 'package:flutter/material.dart';

class OrderView extends StatelessWidget {
  const OrderView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: PageStorageKey('order_page'),
      child: Text(
        'Trang Quản lý Đơn hàng',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}