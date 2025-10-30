import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartFood extends StatefulWidget {
  final List<dynamic> data;
  final List<Color> colors;
  final double totalQuantity;
  final NumberFormat currencyFormatter;

  const ChartFood({
    Key? key,
    required this.data,
    required this.colors,
    required this.totalQuantity,
    required this.currencyFormatter,
  }) : super(key: key);

  @override
  State<ChartFood> createState() => ChartFoodState();
}

class ChartFoodState extends State<ChartFood> {
  int _touchedIndex = -1;
  Offset _touchPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = [];

    for (int i = 0; i < widget.data.length; i++) {
      final item = widget.data[i];
      final double quantity = (item['totalQuantity'] as num).toDouble();
      final double percentage = (quantity / widget.totalQuantity) * 100;
      final bool isTouched = i == _touchedIndex;

      sections.add(
        PieChartSectionData(
          color: widget.colors[i % widget.colors.length],
          value: quantity,
          title: isTouched ? '' : '${percentage.toStringAsFixed(1)}%',
          radius: isTouched ? 165 : 145,
          titleStyle: TextStyle(
            fontSize: isTouched ? 0 : 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 450,
      child: MouseRegion(
        onHover: (event) {
          setState(() {
            _touchPosition = event.localPosition;
          });
        },
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // Chart
            Padding(
              padding: const EdgeInsets.all(20),
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 90,
                  sectionsSpace: 2,
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;

                        if (event is FlPointerHoverEvent) {
                          _touchPosition = event.localPosition;
                        }
                      });
                    },
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 350),
                swapAnimationCurve: Curves.easeOutCubic,
              ),
            ),
            // Center label
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.totalQuantity.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tổng số phần',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tooltip at mouse position
            if (_touchedIndex >= 0 && _touchedIndex < widget.data.length)
              _buildTooltip(),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    final screenSize = MediaQuery.of(context).size;
    final item = widget.data[_touchedIndex];
    final percentage =
        ((item['totalQuantity'] as num).toDouble() /
        widget.totalQuantity *
        100);

    // Calculate tooltip position
    double left = _touchPosition.dx + 20;
    double top = _touchPosition.dy - 100;

    // Adjust if tooltip goes off screen
    const tooltipWidth = 280.0;
    const tooltipHeight = 200.0;

    if (left + tooltipWidth > screenSize.width) {
      left = _touchPosition.dx - tooltipWidth - 20;
    }
    if (top < 0) {
      top = 20;
    }
    if (top + tooltipHeight > screenSize.height) {
      top = screenSize.height - tooltipHeight - 20;
    }

    return Positioned(
      left: left.clamp(20.0, screenSize.width - tooltipWidth - 20),
      top: top.clamp(20.0, screenSize.height - tooltipHeight - 20),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (value * 0.2),
            alignment: Alignment.topLeft,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: widget.colors[_touchedIndex % widget.colors.length]
                    .withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with rank
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.colors[_touchedIndex % widget.colors.length],
                          widget.colors[_touchedIndex % widget.colors.length]
                              .withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: widget
                              .colors[_touchedIndex % widget.colors.length]
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${_touchedIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['foodName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1a1a1a),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Số lượng',
                      value: '${item['totalQuantity']} phần',
                      color:
                          widget.colors[_touchedIndex % widget.colors.length],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.percent_rounded,
                      label: 'Tỷ lệ',
                      value: '${percentage.toStringAsFixed(1)}%',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              if (item['totalRevenue'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade50,
                        Colors.green.shade100.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doanh thu',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.currencyFormatter.format(
                              (item['totalRevenue'] as num).toDouble(),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
