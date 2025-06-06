part of 'app_pages.dart';

// Define all routes
abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const BOTTOM_NAV = _Paths.BOTTOM_NAV;

  static const FORGOT = _Paths.FORGOT;
  static const SORTVIEW = _Paths.SORTVIEW;
  static const FILTERVIEW = _Paths.FILTERVIEW;
  static const VIEWDETAIL = _Paths.VIEWDETAIL;

}

// Define route paths
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const BOTTOM_NAV = '/bottom_nav';

  static const FORGOT = '/forgot';
  static const SORTVIEW = '/sort';
  static const FILTERVIEW = '/filter';
  static const VIEWDETAIL = '/detail';

}
