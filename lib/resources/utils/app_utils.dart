import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
// Import BaseModal (đảm bảo đường dẫn đúng)
import 'package:ql_moifood_app/resources/widgets/modals/base_modal.dart'; 

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
      // Check if the overlay entry is still mounted before removing
      // This can prevent errors if the widget is disposed before the delay finishes
      try {
        overlayEntry.remove();
      } catch (e) {
        // Handle potential error if entry is already removed or context is invalid
        debugPrint("Error removing SnackBar overlay: $e");
      }
    });
  }

  /// Lấy cấu hình màu sắc và icon theo loại
  static _SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          gradientColors: [
            const Color(0xFF4CAF50),
            const Color(0xFF66BB6A),
          ],
          icon: Icons.check_circle_rounded,
          shadowColor: const Color(0xFF4CAF50),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          gradientColors: [
            const Color(0xFFFF9800),
            const Color(0xFFFFB74D),
          ],
          icon: Icons.warning_rounded,
          shadowColor: const Color(0xFFFF9800),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          gradientColors: [
            const Color(0xFFF44336),
            const Color(0xFFE57373),
          ],
          icon: Icons.error_rounded,
          shadowColor: const Color(0xFFF44336),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          gradientColors: [
            const Color(0xFF2196F3),
            const Color(0xFF64B5F6),
          ],
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
    // Check if a dialog is currently open before trying to pop
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Hiển thị Confirmation Dialog
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

  // **** THÊM LẠI HÀM NÀY ****
  /// Hiển thị Modal cơ bản có thể tái sử dụng
  static Future<T?> showBaseModal<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? primaryAction,
    Widget? secondaryAction,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Modal',
      pageBuilder: (context, anim1, anim2) {
        // Đảm bảo BaseModal được import đúng
        return BaseModal( 
          title: title,
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
          child: child,
        );
      },
      // Animation (Scale và Fade)
      transitionBuilder: (context, anim1, anim2, widgetChild) { // Đổi tên child thành widgetChild
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            // Sử dụng widgetChild thay vì child
            child: widgetChild, 
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300), // Thêm duration
    );
  }
  // **************************
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
  bool _isVisible = true; // State to control removal

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    // Auto dismiss animation
    Future.delayed(
      widget.duration - const Duration(milliseconds: 400),
      () {
        if (mounted) {
          _closeNotification(); // Call close method
        }
      },
    );
  }

  // Method to handle closing animation and state update
  void _closeNotification() {
    if (mounted && _isVisible) {
      _controller.reverse().then((_) {
        if (mounted) {
           setState(() {
            _isVisible = false; // Mark as not visible to prevent rebuild errors
          });
          // Note: Actual removal is handled by the caller using OverlayEntry.remove()
        }
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
    if (!_isVisible) return const SizedBox.shrink(); // Don't build if not visible

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
              constraints: BoxConstraints(
                maxWidth: size.width - 32,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.config.gradientColors.first.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: widget.config.shadowColor.withOpacity(0.2),
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
                          color: widget.config.shadowColor.withOpacity(0.3),
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
                      // Call close method on tap
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
    // Determine title based on the icon for consistency
    if (widget.config.icon == Icons.check_circle_rounded) return 'Thành công';
    if (widget.config.icon == Icons.warning_rounded) return 'Cảnh báo';
    if (widget.config.icon == Icons.error_rounded) return 'Lỗi';
    return 'Thông báo'; // Default title
  }
}


/// Modern Alert Dialog
class _ModernAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final _SnackBarConfig config;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool? isMobile;

  const _ModernAlertDialog({
    required this.title,
    required this.message,
    required this.config,
    required this.buttonText,
    this.onPressed,
    this.isMobile,
  });

  @override
  State<_ModernAlertDialog> createState() => _ModernAlertDialogState();
}

class _ModernAlertDialogState extends State<_ModernAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
    // Thêm logic responsive
    final bool isMobile =
        widget.isMobile ?? MediaQuery.of(context).size.width < 600;

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon với animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
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
                          color: widget.config.shadowColor.withOpacity(0.4),
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
                ),
                SizedBox(height: isMobile ? 20 : 24),

                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
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
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 24 : 28),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.config.gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: widget.config.shadowColor.withOpacity(0.4),
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
                          padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 14 : 16),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Loading Dialog hiện đại
class _ModernLoadingDialog extends StatelessWidget {
  final String? message;

  const _ModernLoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
class _ModernConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;

  const _ModernConfirmDialog({
    super.key,
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
  late Animation<double> _fadeAnimation;

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
    // SỬA LỖI: Dùng confirmColor hoặc màu cam mặc định
    final Color color = widget.confirmColor ?? AppColor.orange;
    final Color shadowColor = color;
    // SỬA LỖI: Đặt icon mặc định
    const IconData icon = Icons.help_outline_rounded;


    // Logic Responsive
    final bool isMobile = MediaQuery.of(context).size.width < 600;

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.2),
                          color.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: isMobile ? 40 : 48,
                      color: color,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),

                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
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
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 24 : 28),

                // Buttons
                if (!isMobile)
                  Row(
                    children: [
                      Expanded(child: _buildCancelButton(isMobile)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildConfirmButton(color, isMobile)),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildConfirmButton(color, isMobile),
                      const SizedBox(height: 10),
                      _buildCancelButton(isMobile),
                    ],
                  ),
              ],
            ),
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
            colors: [confirmColor, confirmColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: confirmColor.withOpacity(0.4),
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