import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/statistic_viewmodel.dart';
import 'package:ql_moifood_app/views/reports/widgets/chart/chart_food.dart';

class FoodStatsChartSection extends StatelessWidget {
  final AnimationController animation;
  final NumberFormat currencyFormatter;

  const FoodStatsChartSection({
    super.key,
    required this.animation,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticViewModel>();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (animation.value * 0.2),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.orange.shade50.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.orange.shade100.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Top món ăn bán chạy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Gọi hàm build biểu đồ bên dưới
            _buildFoodPieChart(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodPieChart(
    BuildContext context,
    StatisticViewModel viewModel,
  ) {
    if (viewModel.isLoadingFoodStats) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (viewModel.errorMessage != null && viewModel.foodStatsData == null) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Lỗi tải dữ liệu',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.foodStatsData == null ||
        viewModel.foodStatsData['mostOrdered'] == null ||
        viewModel.foodStatsData['mostOrdered'].isEmpty) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_outlined,
                size: 56,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có dữ liệu',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    final List<dynamic> data = viewModel.foodStatsData['mostOrdered'];
    final double totalQuantity = data.fold(
      0.0,
      (sum, item) => sum + (item['totalQuantity'] as num).toDouble(),
    );

    final List<Color> colors = [
      Colors.blue.shade500,
      Colors.red.shade500,
      Colors.green.shade500,
      Colors.orange.shade500,
      Colors.purple.shade500,
      Colors.teal.shade500,
      Colors.pink.shade500,
      Colors.indigo.shade500,
      Colors.amber.shade500,
      Colors.cyan.shade500,
    ];

    return ChartFood(
      data: data,
      colors: colors,
      totalQuantity: totalQuantity,
      currencyFormatter: currencyFormatter,
    );
  }
}
