import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/helpers/auth_storage.dart';
import 'package:ql_moifood_app/resources/theme/theme.dart';
import 'package:ql_moifood_app/viewmodels/auth_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/category_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/food_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/profile_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/reviews_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/statistic_viewmodel.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/views/auth/login_view.dart';
import 'package:ql_moifood_app/views/Dashboard/Dashboard_view.dart';
import 'package:ql_moifood_app/views/category/category_view.dart';
import 'package:ql_moifood_app/views/customer/user_view.dart';
import 'package:ql_moifood_app/views/manage_food/food_view.dart';
import 'package:ql_moifood_app/views/manage_orders/order_view.dart';
import 'package:ql_moifood_app/views/notification/notification_view.dart';
import 'package:ql_moifood_app/views/reports/statistic_view.dart';
import 'package:ql_moifood_app/views/review/review_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN', null);
  await dotenv.load(fileName: ".env");

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
        ChangeNotifierProvider(create: (_) => FoodViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => StatisticViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
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
        FoodView.routeName: (context) => const FoodView(),
        OrderView.routeName: (context) => const OrderView(),
        StatisticView.routeName: (context) => const StatisticView(),
        UserView.routeName: (context) => const UserView(),
        ReviewView.routeName: (context) => const ReviewView(),
        NotificationView.routeName: (context) => const NotificationView(),
      },
    );
  }
}
