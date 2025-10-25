import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/widgets/TextFormField/custom_text_field.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
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
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white.withValues(alpha: 0.09),
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
                    size: 50,
                    width: double.infinity,
                    height: 55,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Dashboard.routeName,
                      );
                    },
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
