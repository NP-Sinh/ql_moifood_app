import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ql_moifood_app/views/reports/widgets/chart/food_stats_chart_section.dart';
import 'package:ql_moifood_app/views/reports/widgets/chart/order_count_chart_section.dart';
import 'package:ql_moifood_app/views/reports/widgets/chart/revenue_chart_section.dart';

class StatisticChartsTab extends StatelessWidget {
  final NumberFormat currencyFormatter;
  final AnimationController animation;

  const StatisticChartsTab({
    Key? key,
    required this.currencyFormatter,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row cho 2 chart đầu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Component con 1: Doanh thu
              Expanded(
                child: RevenueChartSection(
                  animation: animation,
                  currencyFormatter: currencyFormatter,
                ),
              ),
              const SizedBox(width: 20),
              // Component con 2: Đơn hàng
              Expanded(
                child: OrderCountChartSection(
                  animation: animation,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Component con 3: Top món ăn
          FoodStatsChartSection(
            animation: animation,
            currencyFormatter: currencyFormatter,
          ),
        ],
      ),
    );
  }
}