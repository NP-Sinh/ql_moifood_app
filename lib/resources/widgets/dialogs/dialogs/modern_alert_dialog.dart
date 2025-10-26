import 'package:flutter/material.dart';
import '../configs/snackbar_config.dart';

class ModernAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final SnackBarConfig config;
  final String buttonText;
  final VoidCallback? onPressed;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.config,
    required this.buttonText,
    this.onPressed,
  });

  @override
  State<ModernAlertDialog> createState() => _ModernAlertDialogState();
}

class _ModernAlertDialogState extends State<ModernAlertDialog>
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: _buildDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedIcon(isMobile),
                SizedBox(height: isMobile ? 20 : 24),
                _buildTitle(isMobile),
                SizedBox(height: isMobile ? 8 : 12),
                _buildMessage(isMobile),
                SizedBox(height: isMobile ? 24 : 28),
                _buildButton(isMobile),
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

  Widget _buildAnimatedIcon(bool isMobile) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 600),
    curve: Curves.elasticOut,
    builder: (context, value, child) =>
        Transform.scale(scale: value, child: child),
    child: Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.config.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.config.shadowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        widget.config.icon,
        size: isMobile ? 40 : 48,
        color: Colors.white,
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

  Widget _buildButton(bool isMobile) => SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: widget.config.gradientColors),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: widget.config.shadowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.onPressed?.call();
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
            child: Text(
              widget.buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 15 : 16,
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
