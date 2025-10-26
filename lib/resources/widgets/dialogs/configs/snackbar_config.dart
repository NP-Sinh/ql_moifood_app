import 'package:flutter/material.dart';

enum SnackBarType { success, warning, error, info }

class SnackBarConfig {
  final List<Color> gradientColors;
  final IconData icon;
  final Color shadowColor;
  final String title;

  const SnackBarConfig({
    required this.gradientColors,
    required this.icon,
    required this.shadowColor,
    required this.title,
  });

  factory SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const SnackBarConfig(
          gradientColors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          icon: Icons.check_circle_rounded,
          shadowColor: Color(0xFF4CAF50),
          title: 'Thành công',
        );
      case SnackBarType.warning:
        return const SnackBarConfig(
          gradientColors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          icon: Icons.warning_rounded,
          shadowColor: Color(0xFFFF9800),
          title: 'Cảnh báo',
        );
      case SnackBarType.error:
        return const SnackBarConfig(
          gradientColors: [Color(0xFFF44336), Color(0xFFE57373)],
          icon: Icons.error_rounded,
          shadowColor: Color(0xFFF44336),
          title: 'Lỗi',
        );
      case SnackBarType.info:
        return const SnackBarConfig(
          gradientColors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          icon: Icons.info_rounded,
          shadowColor: Color(0xFF2196F3),
          title: 'Thông báo',
        );
    }
  }
}
