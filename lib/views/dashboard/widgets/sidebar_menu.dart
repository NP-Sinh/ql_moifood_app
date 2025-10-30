import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class SidebarMenu extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final List<Map<String, dynamic>> menuItems;
  final int selectedIndex;
  final ValueChanged<int> onMenuItemTap;

  const SidebarMenu({
    super.key,
    required this.isDesktop,
    required this.isTablet,
    required this.menuItems,
    required this.selectedIndex,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = isDesktop ? 280.0 : (isTablet ? 80.0 : 0.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.orange.withValues(alpha: 0.9),
            AppColor.orange.withValues(alpha: 0.9),
          ], 
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.orange.withValues(alpha: 0.2), 
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2), 
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOI FOOD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Admin Panel',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedIndex == index;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 200 + (index * 50)),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(-20 * (1 - value), 0),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onMenuItemTap(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(item['icon'], color: Colors.white, size: 24),
                              if (isDesktop) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item['label'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // User Profile
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: AppColor.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'admin@moifood.com',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
