import 'package:flutter/material.dart';

/// Trang Thống kê (Placeholder)
class StatisticsView extends StatelessWidget {
  const StatisticsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: PageStorageKey('analytics_page'),
      child: Text(
        'Trang Thống kê',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
