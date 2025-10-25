
import 'package:flutter/material.dart';

class FoodView extends StatelessWidget {
  const FoodView();

  @override
  Widget build(BuildContext context) {
    // Thêm PageStorageKey để giữ state khi chuyển tab
    return const Center(
      key: PageStorageKey('food_page'),
      child: Text(
        'Trang Quản lý Món ăn',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}