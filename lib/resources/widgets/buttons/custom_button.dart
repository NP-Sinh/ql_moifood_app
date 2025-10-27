import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? label;
  final Widget? icon; // Cho phép truyền bất kỳ widget nào (Icon, Image, Svg, v.v.)
  final double size;
  final double borderRadius;
  final bool showShadow;
  final List<Color>? gradientColors;
  final double? iconSize;
  final double? fontSize; 
  final double? width;
  final double? height;
  final String? tooltip;

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
    this.tooltip,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _hasLabel => widget.label != null && widget.label!.isNotEmpty;
  bool get _hasIcon => widget.icon != null;
  bool get _hasTooltip => widget.tooltip != null && widget.tooltip!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradientColors ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        ];

    final double iconSize = widget.iconSize ?? widget.size * 0.5;
    final double fontSize = widget.fontSize ?? widget.size * 0.35;

    final buttonContent = ScaleTransition(
      scale: _controller,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            width: widget.width,
            height: widget.height ?? widget.size,
            constraints: BoxConstraints(
              minWidth: _hasLabel ? widget.size * 1.5 : widget.size,
            ),
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
      ),
    );
    if (_hasTooltip) {
      return Tooltip(
        message: widget.tooltip,
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}