import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/modals/base_modal.dart';

enum SnackBarType { success, warning, error, info }

class AppUtils {
  AppUtils._();

  // ==================== SNACKBAR ====================
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.success,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final config = _SnackBarConfig.fromType(type);
    final overlay = Overlay.of(context);
    final effectiveDuration = duration ?? const Duration(seconds: 3);

    final overlayEntry = OverlayEntry(
      builder: (context) => _WindowsStyleNotification(
        message: message,
        config: config,
        duration: effectiveDuration,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(effectiveDuration, () {
      try {
        overlayEntry.remove();
      } catch (e) {
        debugPrint("Error removing SnackBar overlay: $e");
      }
    });
  }

  // ==================== DIALOGS ====================
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
  }) {
    final config = _SnackBarConfig.fromType(type);

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

  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Hoàn tất',
    VoidCallback? onPressed,
  }) => showAlertDialog(
    context,
    title: title,
    message: message,
    type: SnackBarType.success,
    buttonText: buttonText,
    onPressed: onPressed,
  );

  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
  }) => showAlertDialog(
    context,
    title: title,
    message: message,
    type: SnackBarType.error,
    buttonText: buttonText,
    onPressed: onPressed,
  );

  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Đã hiểu',
    VoidCallback? onPressed,
  }) => showAlertDialog(
    context,
    title: title,
    message: message,
    type: SnackBarType.warning,
    buttonText: buttonText,
    onPressed: onPressed,
  );

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color? confirmColor,
  }) => showDialog<bool>(
    context: context,
    builder: (context) => _ModernConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
    ),
  );

  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // ==================== MODAL ====================
  static Future<T?> showBaseModal<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? primaryAction,
    Widget? secondaryAction,
  }) => showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Modal',
    pageBuilder: (context, anim1, anim2) => BaseModal(
      title: title,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      child: child,
    ),
    transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
      opacity: anim1,
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ),
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// ==================== CONFIG ====================
class _SnackBarConfig {
  final List<Color> gradientColors;
  final IconData icon;
  final Color shadowColor;
  final String title;

  const _SnackBarConfig({
    required this.gradientColors,
    required this.icon,
    required this.shadowColor,
    required this.title,
  });

  factory _SnackBarConfig.fromType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const _SnackBarConfig(
          gradientColors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          icon: Icons.check_circle_rounded,
          shadowColor: Color(0xFF4CAF50),
          title: 'Thành công',
        );
      case SnackBarType.warning:
        return const _SnackBarConfig(
          gradientColors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          icon: Icons.warning_rounded,
          shadowColor: Color(0xFFFF9800),
          title: 'Cảnh báo',
        );
      case SnackBarType.error:
        return const _SnackBarConfig(
          gradientColors: [Color(0xFFF44336), Color(0xFFE57373)],
          icon: Icons.error_rounded,
          shadowColor: Color(0xFFF44336),
          title: 'Lỗi',
        );
      case SnackBarType.info:
        return const _SnackBarConfig(
          gradientColors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          icon: Icons.info_rounded,
          shadowColor: Color(0xFF2196F3),
          title: 'Thông báo',
        );
    }
  }
}

// ==================== NOTIFICATION ====================
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
        if (mounted) {
          setState(() => _isVisible = false);
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
              decoration: _buildNotificationDecoration(),
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

  BoxDecoration _buildNotificationDecoration() => BoxDecoration(
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
        child: Icon(Icons.close_rounded, size: 20, color: Colors.grey.shade600),
      ),
    ),
  );
}

// ==================== ALERT DIALOG ====================
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
            decoration: _buildDialogDecoration(),
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

  BoxDecoration _buildDialogDecoration() => BoxDecoration(
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

// ==================== CONFIRM DIALOG ====================
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
            decoration: _buildDialogDecoration(),
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

  BoxDecoration _buildDialogDecoration() => BoxDecoration(
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
