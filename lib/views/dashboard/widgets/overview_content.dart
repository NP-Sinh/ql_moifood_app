import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class OverviewContent extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const OverviewContent({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey('overview'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(isDesktop, isTablet),
          const SizedBox(height: 24),
          _buildChartsSection(isDesktop, isTablet),
          const SizedBox(height: 24),
          _buildRecentOrdersAndTopProducts(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isDesktop, bool isTablet) {
    final stats = [
      {
        'title': 'Tổng doanh thu',
        'value': '125,000,000',
        'change': '+12.5%',
        'icon': Icons.attach_money_rounded,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Đơn hàng',
        'value': '1,234',
        'change': '+8.2%',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Khách hàng',
        'value': '8,549',
        'change': '+15.3%',
        'icon': Icons.people_rounded,
        'color': AppColor.orange,
      },
      {
        'title': 'Món ăn',
        'value': '156',
        'change': '+3.1%',
        'icon': Icons.restaurant_menu_rounded,
        'color': const Color(0xFF9C27B0),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (!isDesktop && isTablet) {
          crossAxisCount = 2;
        } else if (!isDesktop && !isTablet) {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      (stat['color'] as Color).withValues(
                        alpha: 0.05,
                      ), // ĐÃ SỬA
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (stat['color'] as Color).withValues(
                      alpha: 0.2,
                    ), // ĐÃ SỬA
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (stat['color'] as Color).withValues(
                        alpha: 0.1,
                      ), // ĐÃ SỬA
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (stat['color'] as Color).withValues(
                          alpha: 0.15,
                        ), // ĐÃ SỬA
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        color: stat['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            stat['title'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  stat['value'] as String,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.15), // ĐÃ SỬA
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  stat['change'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChartsSection(bool isDesktop, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: isDesktop ? 2 : 1, child: _buildRevenueChart()),
        if (isDesktop) ...[
          const SizedBox(width: 24),
          Expanded(child: _buildOrderStatusChart()),
        ],
      ],
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ĐÃ SỬA
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doanh thu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '7 ngày gần đây',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tuần này',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(height: 250, child: _buildChartBars()),
        ],
      ),
    );
  }

  Widget _buildChartBars() {
    final data = [
      {'day': 'T2', 'value': 0.7},
      {'day': 'T3', 'value': 0.5},
      {'day': 'T4', 'value': 0.9},
      {'day': 'T5', 'value': 0.6},
      {'day': 'T6', 'value': 1.0},
      {'day': 'T7', 'value': 0.8},
      {'day': 'CN', 'value': 0.75},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: data.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: item['value'] as double),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      height: 200 * value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.orange,
                            AppColor.orange.withValues(alpha: 0.6), // ĐÃ SỬA
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  item['day'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderStatusChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ĐÃ SỬA
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trạng thái đơn hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildOrderStatusItem('Chờ xác nhận', 45, const Color(0xFFFF9800)),
          _buildOrderStatusItem('Đã xác nhận', 120, const Color(0xFF2196F3)),
          _buildOrderStatusItem('Hoàn thành', 890, const Color(0xFF4CAF50)),
          _buildOrderStatusItem('Đã hủy', 23, const Color(0xFFF44336)),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem(String label, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15), // ĐÃ SỬA
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersAndTopProducts(bool isDesktop, bool isTablet) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildRecentOrders()),
          const SizedBox(width: 24),
          Expanded(child: _buildTopProducts()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildRecentOrders(),
          const SizedBox(height: 24),
          _buildTopProducts(),
        ],
      );
    }
  }

  Widget _buildRecentOrders() {
    final orders = [
      {
        'id': '#12345',
        'customer': 'Nguyễn Văn A',
        'amount': 250000.0,
        'status': 'Pending',
        'time': '10 phút trước',
      },
      {
        'id': '#12344',
        'customer': 'Trần Thị B',
        'amount': 180000.0,
        'status': 'Confirmed',
        'time': '25 phút trước',
      },
      {
        'id': '#12343',
        'customer': 'Lê Văn C',
        'amount': 320000.0,
        'status': 'Completed',
        'time': '1 giờ trước',
      },
      {
        'id': '#12342',
        'customer': 'Phạm Thị D',
        'amount': 150000.0,
        'status': 'Completed',
        'time': '2 giờ trước',
      },
      {
        'id': '#12342',
        'customer': 'Phạm Thị D',
        'amount': 150000.0,
        'status': 'Completed',
        'time': '2 giờ trước',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ĐÃ SỬA
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đơn hàng gần đây',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
            ],
          ),
          const SizedBox(height: 16),
          ...orders.map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    Color statusColor;
    switch (order['status']) {
      case 'Pending':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'Confirmed':
        statusColor = const Color(0xFF2196F3);
        break;
      case 'Completed':
        statusColor = const Color(0xFF4CAF50);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.orange.withValues(alpha: 0.1), // ĐÃ SỬA
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColor.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order['id'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15), // ĐÃ SỬA
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order['status'],
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order['customer'],
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatVND(order['amount']),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order['time'],
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    final products = [
      {
        'name': 'Phở bò đặc biệt',
        'sales': 234,
        'revenue': 18720000.0,
        'image': '🍜',
      },
      {
        'name': 'Cơm gà xối mỡ',
        'sales': 189,
        'revenue': 15120000.0,
        'image': '🍗',
      },
      {
        'name': 'Bún chả Hà Nội',
        'sales': 156,
        'revenue': 12480000.0,
        'image': '🍲',
      },
      {
        'name': 'Bánh mì thịt',
        'sales': 145,
        'revenue': 8700000.0,
        'image': '🥖',
      },
      {
        'name': 'Cà phê sữa đá',
        'sales': 312,
        'revenue': 9360000.0,
        'image': '☕',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ĐÃ SỬA
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Món ăn bán chạy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.orange.withValues(alpha: 0.2), // ĐÃ SỬA
                      AppColor.orange.withValues(alpha: 0.1), // ĐÃ SỬA
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: AppColor.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Top 5',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade50, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    // Rank badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: index == 0
                              ? [
                                  const Color(0xFFFFD700),
                                  const Color(0xFFFFB800),
                                ]
                              : [Colors.grey.shade300, Colors.grey.shade200],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (index == 0)
                            BoxShadow(
                              color: const Color(
                                0xFFFFD700,
                              ).withValues(alpha: 0.3), // ĐÃ SỬA
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: index == 0
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Product emoji icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.orange.withValues(alpha: 0.1), // ĐÃ SỬA
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        product['image'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_rounded,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product['sales']} đơn',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Revenue
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatVND(product['revenue'] as double),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.15), // ĐÃ SỬA
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_upward_rounded,
                                size: 10,
                                color: Color(0xFF4CAF50),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${12 + index}%',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
