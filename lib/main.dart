import 'package:flutter/material.dart';
import 'package:ql_moifood_app/resources/theme/theme.dart';
import 'package:ql_moifood_app/views/auth/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOI FOOD',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: LoginView.routeName,
      routes: {LoginView.routeName: (context) => const LoginView()},
    );
  }
}
