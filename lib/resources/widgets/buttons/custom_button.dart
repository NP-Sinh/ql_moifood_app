import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? label;
  final Widget? icon; // Cho phép truyền bất kỳ widget nào (Icon, Image, Svg, v.v.)
  final double size; // Kích thước tổng thể
  final double borderRadius;
  final bool showShadow;
  final List<Color>? gradientColors;
  final double? iconSize; // Tuỳ chỉnh kích thước icon
  final double? fontSize; // Tuỳ chỉnh kích thước chữ
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    this.onTap,
    this.label,
    this.icon,
    this.size = 40,
    this.iconSize,
    this.fontSize,
    this.borderRadius = 12,
    this.showShadow = true,
    this.gradientColors,
    this.width,
    this.height,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _hasLabel => widget.label != null && widget.label!.isNotEmpty;
  bool get _hasIcon => widget.icon != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = widget.iconSize ?? widget.size * 0.5;
    final double fontSize = widget.fontSize ?? widget.size * 0.35;

    final gradientColors =
        widget.gradientColors ?? [Colors.red.shade400, Colors.red.shade600];

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: _controller.reverse,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.9).animate(_controller),
        child: Container(
          width: widget.width,
          height: widget.height ?? widget.size * 1.5,
          padding: EdgeInsets.symmetric(
            horizontal: _hasLabel ? widget.size * 0.4 : widget.size * 0.25,
            vertical: widget.size * 0.25,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.showShadow
                ? [
                    BoxShadow(
                      color: gradientColors.last.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_hasIcon)
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Center(child: widget.icon),
                ),
              if (_hasIcon && _hasLabel) const SizedBox(width: 6),
              if (_hasLabel)
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

