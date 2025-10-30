import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/widgets/modals/base_modal.dart';
import 'configs/snackbar_config.dart';
import 'notifications/windows_style_notification.dart';
import 'dialogs/modern_alert_dialog.dart';
import 'dialogs/modern_confirm_dialog.dart';

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
    final config = SnackBarConfig.fromType(type);
    final overlay = Overlay.of(context);
    final effectiveDuration = duration ?? const Duration(seconds: 3);

    final overlayEntry = OverlayEntry(
      builder: (context) => WindowsStyleNotification(
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
    final config = SnackBarConfig.fromType(type);

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ModernAlertDialog(
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
    builder: (context) => ModernConfirmDialog(
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
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
  }) => showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Modal',
    pageBuilder: (context, anim1, anim2) => BaseModal(
      title: title,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      child: child,
      width: width,
      height: height,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
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
