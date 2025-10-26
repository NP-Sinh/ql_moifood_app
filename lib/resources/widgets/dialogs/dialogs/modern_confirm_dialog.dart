import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class ModernConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;

  const ModernConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.confirmColor,
  });

  @override
  State<ModernConfirmDialog> createState() => _ModernConfirmDialogState();
}

class _ModernConfirmDialogState extends State<ModernConfirmDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final color = widget.confirmColor ?? AppColor.orange;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: _buildDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedIcon(isMobile, color),
                SizedBox(height: isMobile ? 20 : 24),
                _buildTitle(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildMessage(isMobile),
                SizedBox(height: isMobile ? 24 : 28),
                _buildButtons(isMobile, color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade50],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 40,
        offset: const Offset(0, 20),
        spreadRadius: -5,
      ),
    ],
  );

  Widget _buildAnimatedIcon(bool isMobile, Color color) =>
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.help_outline_rounded,
            size: isMobile ? 40 : 48,
            color: color,
          ),
        ),
      );

  Widget _buildTitle(bool isMobile) => Text(
    widget.title,
    style: TextStyle(
      fontSize: isMobile ? 20 : 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      letterSpacing: -0.5,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildMessage(bool isMobile) => Text(
    widget.message,
    style: TextStyle(
      fontSize: isMobile ? 14 : 15,
      color: Colors.grey.shade700,
      height: 1.6,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildButtons(bool isMobile, Color confirmColor) => isMobile
      ? Column(
          children: [
            _buildConfirmButton(confirmColor, isMobile),
            const SizedBox(height: 10),
            _buildCancelButton(isMobile),
          ],
        )
      : Row(
          children: [
            Expanded(child: _buildCancelButton(isMobile)),
            const SizedBox(width: 12),
            Expanded(child: _buildConfirmButton(confirmColor, isMobile)),
          ],
        );

  Widget _buildCancelButton(bool isMobile) => SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, false),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
            child: Text(
              widget.cancelText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildConfirmButton(Color confirmColor, bool isMobile) => SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [confirmColor, confirmColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: confirmColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, true),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
            child: Text(
              widget.confirmText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
