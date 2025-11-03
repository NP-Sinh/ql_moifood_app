import 'package:flutter/services.dart';
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

String formatDateTime2(DateTime? date) {
  if (date == null) return '';
  final formatter = DateFormat('HH:mm dd/MM/yyyy', 'vi_VN');
  return formatter.format(date);
}


// định dạng tiền tệ
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###", "vi_VN");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Xóa ký tự không phải số
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Định dạng theo kiểu 20.000 VND
    final number = int.parse(digits);
    final newText = '${_formatter.format(number)} VND';

    // Trả về giá trị mới
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - 4),
    );
  }
}
