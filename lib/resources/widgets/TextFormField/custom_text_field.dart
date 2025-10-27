import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Color? labelColor;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

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
    this.inputFormatters,
    this.maxLines,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultHintColor = isDarkMode ? Colors.white60 : Colors.grey.shade500;

    Widget labelWidget = const SizedBox.shrink();
    if (widget.labelText != null &&
        widget.labelPosition == LabelPosition.outside) {
      labelWidget = Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
        child: Text(
          widget.labelText!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
                widget.labelColor ??
                (isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.isPassword ? 1 : widget.maxLines,

          decoration: InputDecoration(
            labelText: widget.labelPosition == LabelPosition.inside
                ? widget.labelText
                : null,
            labelStyle: TextStyle(
              color: widget.labelColor ?? defaultHintColor,
              fontWeight: FontWeight.w400,
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
