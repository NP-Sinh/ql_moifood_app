import 'package:flutter/material.dart';
import '../configs/snackbar_config.dart';

class WindowsStyleNotification extends StatefulWidget {
  final String message;
  final SnackBarConfig config;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;

  const WindowsStyleNotification({
    super.key,
    required this.message,
    required this.config,
    required this.duration,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<WindowsStyleNotification> createState() =>
      _WindowsStyleNotificationState();
}

class _WindowsStyleNotificationState extends State<WindowsStyleNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _scheduleAutoDismiss();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  void _scheduleAutoDismiss() {
    Future.delayed(widget.duration - const Duration(milliseconds: 400), () {
      if (mounted) _closeNotification();
    });
  }

  void _closeNotification() {
    if (mounted && _isVisible) {
      _controller.reverse().then((_) {
        if (mounted) setState(() => _isVisible = false);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;

    return Positioned(
      top: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 380,
              constraints: BoxConstraints(maxWidth: size.width - 32),
              padding: const EdgeInsets.all(16),
              decoration: _buildDecoration(),
              child: Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 16),
                  _buildMessage(),
                  const SizedBox(width: 8),
                  _buildCloseButton(),
                ],
              ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.config.gradientColors.first.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: widget.config.shadowColor.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 15),
            spreadRadius: -10,
          ),
        ],
      );

  Widget _buildIcon() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.config.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.config.shadowColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(widget.config.icon, color: Colors.white, size: 28),
      );

  Widget _buildMessage() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.config.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

  Widget _buildCloseButton() => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _closeNotification,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.close_rounded,
              size: 20,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
}