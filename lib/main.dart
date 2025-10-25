import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import 'package:ql_moifood_app/resources/theme/theme.dart';
import 'package:ql_moifood_app/viewmodels/auth_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/profile_viewmodel.dart';
import 'package:ql_moifood_app/views/auth/login_view.dart';
import 'package:ql_moifood_app/views/Dashboard/Dashboard_view.dart';
import 'package:ql_moifood_app/views/category/category_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kiểm tra đăng nhập
  final isLoggedIn = await AuthStorage.isLoggedIn();
  String initialRoute = LoginView.routeName;

  if (isLoggedIn) {
    final role = await AuthStorage.getRole();
    if (role == 'Admin') {
      initialRoute = DashboardView.routeName;
    } else {
      initialRoute = LoginView.routeName;
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOI FOOD',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        LoginView.routeName: (context) => const LoginView(),
        DashboardView.routeName: (context) => const DashboardView(),
        CategoryView.routeName: (context) => const CategoryView(),
      },
    );
  }
}
