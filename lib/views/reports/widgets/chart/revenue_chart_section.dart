import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/statistic_viewmodel.dart';

class RevenueChartSection extends StatelessWidget {
  final AnimationController animation;
  final NumberFormat currencyFormatter;

  const RevenueChartSection({
    super.key,
    required this.animation,
    required this.currencyFormatter,
  });

  String _formatPeriod(String period) {
    try {
      final dateTime = DateTime.parse(period);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return period;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticViewModel>();

    final double grandTotal =
        viewModel.isLoadingRevenue || viewModel.revenueData == null
        ? 0.0
        : (viewModel.revenueData['grandTotal'] as num).toDouble();

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
            colors: [Colors.white, Colors.green.shade50.withValues(alpha: 0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.green.shade100.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  PHẦN HEADER
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Doanh thu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // --- TỔNG DOANH THU
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grandTotal == 0.0 && viewModel.isLoadingRevenue
                      ? '... đ'
                      : currencyFormatter.format(grandTotal),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng doanh thu',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // --- BIỂU ĐỒ
            _buildRevenueBarChart(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueBarChart(
    BuildContext context,
    StatisticViewModel viewModel,
  ) {
    if (viewModel.isLoadingRevenue && viewModel.revenueData == null) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null && viewModel.revenueData == null) {
      return SizedBox(
        height: 240,
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

    if (viewModel.revenueData == null ||
        viewModel.revenueData['data'] == null ||
        viewModel.revenueData['data'].isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_chart_outlined_rounded,
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

    final List<dynamic> data = viewModel.revenueData['data'];
    final List<BarChartGroupData> barGroups = [];
    double maxY = 0;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double yValue = (item['totalRevenue'] as num).toDouble();
      maxY = max(maxY, yValue);
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: yValue,
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade600],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 24,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
          ],
        ),
      );
    }

    final double leftInterval = (maxY == 0) ? 1 : (maxY / 5).ceilToDouble();

    final double bottomInterval = (data.length <= 6)
        ? 1
        : (data.length / 5).ceilToDouble();

    // Chỉ trả về biểu đồ
    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: bottomInterval,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _formatPeriod(data[index]['period'].toString()),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 36,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                interval: leftInterval,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('');
                  return Text(
                    NumberFormat.compact(locale: 'vi_VN').format(value),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: null,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBorder: const BorderSide(style: BorderStyle.solid),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = data[groupIndex];
                final period = item['period'];
                final revenue = (item['totalRevenue'] as num).toDouble();
                return BarTooltipItem(
                  '${_formatPeriod(period.toString())}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: currencyFormatter.format(revenue),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
