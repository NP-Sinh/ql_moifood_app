import 'package:flutter/material.dart';

/// Trả về màu chữ tương phản với background.
/// Nếu background sáng → chữ đen.
/// Nếu background tối → chữ trắng.
Color getContrastingTextColor(Color background) {
  // Hàm computeLuminance() trả về độ sáng (0.0 = tối, 1.0 = sáng)
  return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
