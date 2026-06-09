import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/main_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => MainPage(),
    ),
  ];
}
