import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
