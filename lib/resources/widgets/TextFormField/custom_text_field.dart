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
  final bool isSearch;
  final FormFieldValidator<String>? validator;
  final List<Color>? gradientColors;
  final LabelPosition labelPosition;
  final Color? labelColor;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.isPassword = false,
    this.isSearch = false,
    this.validator,
    this.gradientColors = const [Colors.orangeAccent, Colors.deepOrange],
    this.labelPosition = LabelPosition.outside,
    this.labelColor,
    this.hintColor,
    this.inputFormatters,
    this.maxLines,
    this.onChanged,
    this.onClear,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  void _handleClear() {
    widget.controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    setState(() {
      _hasText = false;
    });
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

    // Xác định suffixIcon dựa trên isSearch và isPassword
    Widget? suffixIcon;
    if (widget.isSearch && _hasText) {
      // Nút clear cho search
      suffixIcon = IconButton(
        icon: const Icon(Icons.close_rounded),
        color: defaultHintColor,
        onPressed: _handleClear,
      );
    } else if (widget.isPassword) {
      // Nút toggle password
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: defaultHintColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
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
          onChanged: widget.onChanged,
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
            suffixIcon: suffixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: widget.isSearch
                ? (isDarkMode ? const Color(0xFF303030) : Colors.grey.shade100)
                : (isDarkMode ? const Color(0xFF303030) : AppColor.white),
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.isSearch ? 0 : 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.isSearch ? 24 : 8),
              borderSide: widget.isSearch
                  ? BorderSide.none
                  : BorderSide(
                      color: isDarkMode
                          ? Colors.white30
                          : const Color(0xFFE0E0E0),
                    ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.isSearch ? 24 : 8),
              borderSide: widget.isSearch
                  ? BorderSide.none
                  : BorderSide(
                      color: isDarkMode
                          ? Colors.white30
                          : const Color(0xFFE0E0E0),
                    ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.isSearch ? 24 : 8),
              borderSide: const BorderSide(
                color: AppColor.orange,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
