import 'dart:ui';

import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      homeRefreshCallback?.call();
    } else if (index == 1) {
      redeemRefreshCallback?.call();
    } else if (index == 2) {
      favRefreshCallback?.call();
    }
  }

  VoidCallback? homeRefreshCallback;
  VoidCallback? favRefreshCallback;
  VoidCallback? redeemRefreshCallback;
}
