import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

enum LabelPosition { outside, inside, none }

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final List<Color>? gradientColors;
  final LabelPosition labelPosition;

  // Thêm tùy chọn màu chữ label và hint
  final Color? labelColor;
  final Color? hintColor;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.gradientColors = const [Colors.orangeAccent, Colors.deepOrange],
    this.labelPosition = LabelPosition.outside,
    this.labelColor,
    this.hintColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final hasLabel =
        widget.labelText != null && widget.labelText!.trim().isNotEmpty;

    // phần label hiển thị ngoài
    final labelOutside =
        hasLabel &&
        (widget.labelPosition == LabelPosition.outside ||
            widget.labelPosition == LabelPosition.none);

    // Màu mặc định tự động dựa theo theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultLabelColor = isDarkMode
        ? Colors.white
        : AppColor.black.withValues(alpha: 0.8);
    final defaultHintColor = isDarkMode ? Colors.white70 : AppColor.textLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelOutside) ...[
          Text(
            widget.labelText!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.labelColor ?? defaultLabelColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.labelPosition == LabelPosition.inside
                ? widget.labelText
                : null,
            labelStyle: TextStyle(
              color: widget.labelColor ?? defaultLabelColor,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: widget.hintColor ?? defaultHintColor),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: defaultHintColor)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: defaultHintColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF303030) : AppColor.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white30 : const Color(0xFFE0E0E0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.orange, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
