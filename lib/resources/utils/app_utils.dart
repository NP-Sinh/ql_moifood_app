import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

enum SnackBarType { success, warning, error, info }

class AppUtils {
  // Hiển thị Toast Notification ở góc trên bên phải (Windows style)
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.success,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final config = _getSnackBarConfig(type);
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => _WindowsStyleNotification(
        message: message,
        config: config,
        duration: duration ?? const Duration(seconds: 3),
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );

    overlay.insert(overlayEntry);

    // Auto remove sau duration
    Future.delayed(duration ?? const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  /// Lấy cấu hình màu sắc và icon theo loại
  static _SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          gradientColors: [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
          icon: Icons.check_circle_rounded,
          shadowColor: const Color(0xFF4CAF50),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          gradientColors: [const Color(0xFFFF9800), const Color(0xFFFFB74D)],
          icon: Icons.warning_rounded,
          shadowColor: const Color(0xFFFF9800),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          gradientColors: [const Color(0xFFF44336), const Color(0xFFE57373)],
          icon: Icons.error_rounded,
          shadowColor: const Color(0xFFF44336),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          gradientColors: [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
          icon: Icons.info_rounded,
          shadowColor: const Color(0xFF2196F3),
        );
    }
  }

  /// Hiển thị Alert Dialog với nhiều kiểu
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
  }) {
    final config = _getSnackBarConfig(type);

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ModernAlertDialog(
        title: title,
        message: message,
        config: config,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  /// Hiển thị Success Dialog
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Hoàn tất',
    VoidCallback? onPressed,
  }) {
    return showAlertDialog(
      context,
      title: title,
      message: message,
      type: SnackBarType.success,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Hiển thị Error Dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
  }) {
    return showAlertDialog(
      context,
      title: title,
      message: message,
      type: SnackBarType.error,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Hiển thị Warning Dialog
  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Đã hiểu',
    VoidCallback? onPressed,
  }) {
    return showAlertDialog(
      context,
      title: title,
      message: message,
      type: SnackBarType.warning,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Đóng Loading Dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Hiển thih Confirmation Dialog
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _ModernConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
      ),
    );
  }
}

/// Cấu hình SnackBar
class _SnackBarConfig {
  final List<Color> gradientColors;
  final IconData icon;
  final Color shadowColor;

  _SnackBarConfig({
    required this.gradientColors,
    required this.icon,
    required this.shadowColor,
  });
}

/// Widget Toast Notification kiểu Windows (góc trên phải)
class _WindowsStyleNotification extends StatefulWidget {
  final String message;
  final _SnackBarConfig config;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _WindowsStyleNotification({
    required this.message,
    required this.config,
    required this.duration,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_WindowsStyleNotification> createState() =>
      _WindowsStyleNotificationState();
}

class _WindowsStyleNotificationState extends State<_WindowsStyleNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss animation
    Future.delayed(widget.duration - const Duration(milliseconds: 400), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.config.gradientColors.first.withValues(
                    alpha: 0.3,
                  ),
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
              ),
              child: Row(
                children: [
                  // Icon với gradient background
                  Container(
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
                          color: widget.config.shadowColor.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.config.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getTitle(),
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
                  ),

                  // Close button
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _controller.reverse().then((_) {
                          // Remove overlay khi animation kết thúc
                        });
                      },
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (widget.config.icon == Icons.check_circle_rounded) {
      return 'Thành công';
    } else if (widget.config.icon == Icons.warning_rounded) {
      return 'Cảnh báo';
    } else if (widget.config.icon == Icons.error_rounded) {
      return 'Lỗi';
    } else {
      return 'Thông báo';
    }
  }
}

/// Loading Dialog hiện đại
class ModernLoadingDialog extends StatelessWidget {
  final String? message;

  const ModernLoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loading indicator
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.orange),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Confirm Dialog hiện đại

/// Confirm Dialog hiện đại (responsive)
class _ModernConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;

  const _ModernConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.confirmColor,
  });

  @override
  State<_ModernConfirmDialog> createState() => _ModernConfirmDialogState();
}

class _ModernConfirmDialogState extends State<_ModernConfirmDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
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
    final confirmColor = widget.confirmColor ?? AppColor.orange;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMobile = size.width < 400;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? size.width * 0.9 : 450,
            maxHeight: size.height * 0.8,
          ),
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      confirmColor.withValues(alpha: 0.2),
                      confirmColor.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: isMobile ? 40 : 48,
                  color: confirmColor,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 8 : 12),

              // Message
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 20 : 24),

              // Buttons
              isSmallScreen
                  ? Column(
                      children: [
                        // Confirm button (on top for mobile)
                        _buildConfirmButton(confirmColor, isMobile),
                        const SizedBox(height: 12),
                        // Cancel button
                        _buildCancelButton(isMobile),
                      ],
                    )
                  : Row(
                      children: [
                        // Cancel button
                        Expanded(child: _buildCancelButton(isMobile)),
                        const SizedBox(width: 12),
                        // Confirm button
                        Expanded(
                          child: _buildConfirmButton(confirmColor, isMobile),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(bool isMobile) {
    return SizedBox(
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
  }

  Widget _buildConfirmButton(Color confirmColor, bool isMobile) {
    return SizedBox(
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
}

/// Alert Dialog hiện đại (responsive)
class _ModernAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final _SnackBarConfig config;
  final String buttonText;
  final VoidCallback? onPressed;

  const _ModernAlertDialog({
    required this.title,
    required this.message,
    required this.config,
    required this.buttonText,
    this.onPressed,
  });

  @override
  State<_ModernAlertDialog> createState() => _ModernAlertDialogState();
}

class _ModernAlertDialogState extends State<_ModernAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMobile = size.width < 400;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? size.width * 0.9 : 450,
            maxHeight: size.height * 0.8,
          ),
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.config.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.config.shadowColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.config.icon,
                  size: isMobile ? 40 : 48,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),

              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 8 : 12),

              // Message
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 20 : 24),

              // Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.config.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 12 : 14,
                      ),
                      child: Text(
                        widget.buttonText,
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
            ],
          ),
        ),
      ),
    );
  }
}
