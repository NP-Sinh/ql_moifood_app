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
          radius: isTouched ? 180 : 150,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          badgeWidget: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.colors[i % widget.colors.length].withValues(
                    alpha: isTouched ? 0.7 : 0.5,
                  ),
                  blurRadius: isTouched ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: isTouched ? 14 : 12,
                fontWeight: FontWeight.bold,
                color: widget.colors[i % widget.colors.length],
              ),
            ),
          ),
          badgePositionPercentageOffset: isTouched ? 1.3 : 1.4,
        ),
      );
    }

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 80,
              sectionsSpace: 3,
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
                    _touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 400),
            swapAnimationCurve: Curves.easeInOutCubicEmphasized,
          ),
          // Tooltip khi hover
          if (_touchedIndex >= 0 && _touchedIndex < widget.data.length)
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _touchedIndex >= 0 ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget
                            .colors[_touchedIndex % widget.colors.length]
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: widget.colors[_touchedIndex % widget.colors.length]
                          .withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.colors[_touchedIndex %
                                  widget.colors.length],
                              widget
                                  .colors[_touchedIndex % widget.colors.length]
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: widget
                                  .colors[_touchedIndex % widget.colors.length]
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '#${_touchedIndex + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.data[_touchedIndex]['foodName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: widget
                              .colors[_touchedIndex % widget.colors.length]
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              size: 20,
                              color: widget
                                  .colors[_touchedIndex % widget.colors.length],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.data[_touchedIndex]['totalQuantity']} phần',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.colors[_touchedIndex %
                                        widget.colors.length],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.data[_touchedIndex]['totalRevenue'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: 20,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.currencyFormatter.format(
                                  (widget.data[_touchedIndex]['totalRevenue']
                                          as num)
                                      .toDouble(),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '${((widget.data[_touchedIndex]['totalQuantity'] as num).toDouble() / widget.totalQuantity * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget
                              .colors[_touchedIndex % widget.colors.length],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

