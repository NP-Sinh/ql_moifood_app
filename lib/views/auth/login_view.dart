import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import 'package:ql_moifood_app/resources/utils/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/auth_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/profile_viewmodel.dart';
import 'package:ql_moifood_app/views/dashboard/dashboard_view.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _handleLogin(
    AuthViewModel authVM,
    ProfileViewModel profileVM,
  ) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      AppUtils.showSnackBar(
        context,
        'Vui lòng nhập đầy đủ thông tin',
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => isLoading = true);
    final result = await authVM.login(username, password);
    setState(() => isLoading = false);

    if (result != null) {
      try {
        final token = result.refreshToken.token;
        await profileVM.loadProfile(token);

        if (profileVM.user == null) {
          await Future.delayed(const Duration(milliseconds: 300));
        }

        final role = profileVM.user?.role ?? 'User';
        debugPrint("User role: $role");

        // 🔹 Lưu token + role
        await AuthStorage.saveLogin(token, role: role);

        if (role == 'Admin') {
          Navigator.pushReplacementNamed(context, DashboardView.routeName);
        } else {
          AppUtils.showSnackBar(
            context,
            'Tài khoản không có quyền truy cập trang quản trị',
            type: SnackBarType.error,
          );
        }
      } catch (e) {
        AppUtils.showSnackBar(
          context,
          'Không thể tải hồ sơ người dùng',
          type: SnackBarType.error,
        );
      }
    } else {
      AppUtils.showSnackBar(
        context,
        authVM.errorMessage ?? 'Đăng nhập thất bại',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', height: 150),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: "Tên đăng nhập",
                    hintText: "Nhập tên đăng nhập",
                    controller: usernameController,
                    prefixIcon: Icons.person_outline,
                    labelColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    labelText: "Mật khẩu",
                    hintText: "Nhập mật khẩu",
                    controller: passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    labelColor: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    icon: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                    ),
                    label: "Đăng nhập",
                    gradientColors: [Colors.orangeAccent, Colors.deepOrange],
                    width: double.infinity,
                    height: 55,
                    onTap: isLoading
                        ? null
                        : () => _handleLogin(authVM, profileVM),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
