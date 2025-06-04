import 'package:flutter_ui/views/auth/forgot_password.dart';
import 'package:flutter_ui/views/home/main_view/filter_view.dart';
import 'package:flutter_ui/views/home/main_view/item_details_view.dart';
import 'package:flutter_ui/views/home/main_view/sort_view.dart';
import 'package:flutter_ui/views/splash/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/home/bottom_nav_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV,
      page: () => BottomNavView(),
    ),
    GetPage(
      name: _Paths.FORGOT,
      page: () => const ForgotView(),
    ),
    GetPage(
      name: _Paths.SORTVIEW,
      page: () => const SortView(),
    ),
    GetPage(
      name: _Paths.FILTERVIEW,
      page: () => const FilterView(),
    ),
    GetPage(
      name: _Paths.VIEWDETAIL,
      page: () => const ItemDetailView(),
    ),
  ];
}
