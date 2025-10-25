import 'package:intl/intl.dart';

String formatVND(num vnd) {
  final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return format.format(vnd);
}

String formatDateVN(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy', 'vi_VN');
  return formatter.format(date);
}

String formatDateTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hôm qua, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }