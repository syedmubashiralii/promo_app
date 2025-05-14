import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui/views/home/FavouriteView.dart';
import 'package:flutter_ui/views/home/ProfileView.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../utils/color_helper.dart';
import 'ReedMeView.dart';
import 'home_view.dart';

class BottomNavView extends StatelessWidget {
  HomeController controller = Get.put(HomeController());

  BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.white,
      child: SafeArea(
        child: Scaffold(
          body: Obx(() => IndexedStack(
                index: controller.selectedIndex.value,
                children: [
                  HomeView(),
                  ReedMeView(),
                  FavouriteView(),
                  ProfileView()
                ],
              )),
          bottomNavigationBar: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 64,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: ColorHelper.bgGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => controller.changeTab(0),
                    child: SvgPicture.asset(
                      'assets/images/home.svg',
                      color: controller.selectedIndex.value == 0
                          ? const Color(0xFF007AFF)
                          : ColorHelper.textGrey1,
                    ),
                  ),
                  InkWell(
                      onTap: () => controller.changeTab(1),
                      child: SvgPicture.asset(
                        'assets/images/reedme.svg',
                        height: 24,
                        width: 24,
                        color: controller.selectedIndex.value == 1
                            ? const Color(0xFF007AFF)
                            : ColorHelper.textGrey1,
                      ),
                  ),
                  InkWell(
                      onTap: () => controller.changeTab(2),
                      child: SvgPicture.asset(
                        'assets/images/fav.svg',
                        color: controller.selectedIndex.value == 2
                            ? const Color(0xFF007AFF)
                            : ColorHelper.textGrey1,
                      ),
                  ),
                  InkWell(
                      onTap: () => controller.changeTab(3),
                      child: SvgPicture.asset(
                        'assets/images/profile.svg',
                        height: 24,
                        width: 24,
                        color: controller.selectedIndex.value == 3
                            ? const Color(0xFF007AFF)
                            : ColorHelper.textGrey1,
                      ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
