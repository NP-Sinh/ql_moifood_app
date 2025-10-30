import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/statistic_viewmodel.dart';

class OrderCountChartSection extends StatelessWidget {
  final AnimationController animation;

  const OrderCountChartSection({super.key, required this.animation});

  /// Hàm helper để format ngày tháng
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

    final String grandTotalText =
        viewModel.isLoadingOrderCount || viewModel.orderCountData == null
        ? '--'
        : (viewModel.orderCountData['totalOrders'] ?? 0 as num)
              .toInt()
              .toString();

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
            colors: [Colors.white, Colors.blue.shade50.withValues(alpha: 0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: Colors.blue.shade100.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Đơn hàng',
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
            // Tổng số đơn
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$grandTotalText đơn',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng số đơn hàng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Biểu đồ
            _buildOrderCountLineChart(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCountLineChart(
    BuildContext context,
    StatisticViewModel viewModel,
  ) {
    if (viewModel.isLoadingOrderCount && viewModel.orderCountData == null) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (viewModel.errorMessage != null && viewModel.orderCountData == null) {
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

    if (viewModel.orderCountData == null ||
        viewModel.orderCountData['data'] == null ||
        viewModel.orderCountData['data'].isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_outlined,
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

    final List<dynamic> data = viewModel.orderCountData['data'];
    final List<FlSpot> spots = [];
    double maxY = 0; 

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double yValue = (item['orderCount'] as num).toDouble();
      if (yValue > maxY) {
        maxY = yValue;
      }
      spots.add(FlSpot(i.toDouble(), yValue));
    }
    final double leftInterval = (maxY <= 5) ? 1 : (maxY / 5).ceilToDouble();
    final double bottomInterval = (data.length <= 6)
        ? 1
        : (data.length / 5).ceilToDouble();

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
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
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: bottomInterval,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    final period =
                        data[index]['period'] ??
                        data[index]['periodicTimer'] ??
                        '';
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _formatPeriod(period.toString()),
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
                reservedSize: 45,
                interval: leftInterval,
                getTitlesWidget: (value, meta) {
                  if (value == value.toInt()) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return const Text('');
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
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.4,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.blue.shade600,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade300.withValues(alpha: 0.4),
                    Colors.blue.shade100.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              shadow: Shadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBorder: const BorderSide(style: BorderStyle.solid),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              tooltipMargin: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index >= 0 && index < data.length) {
                    final item = data[index];
                    final period =
                        item['period'] ?? item['periodicTimer'] ?? '';
                    final count = (item['orderCount'] as num).toInt();
                    return LineTooltipItem(
                      '${_formatPeriod(period.toString())}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$count đơn',
                          style: const TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return null;
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
