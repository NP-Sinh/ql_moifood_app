import 'package:flutter/material.dart';

class CustomerView extends StatelessWidget {
  const CustomerView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: PageStorageKey('customer_page'),
      child: Text(
        'Trang Quản lý Khách hàng',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}