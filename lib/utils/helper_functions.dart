import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/widgets/loading_dialog.dart';
import 'package:get/get.dart';

class HelperFunctions {

  static void showLoadingDialog({String? text}) {
    if (!Get.isDialogOpen!) {
      Get.dialog(LoadingDialog(text: text,));
    }
  }

  static void closeDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static Future<void> launchUrl(String url) async {
   /* final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $url');
    }*/
  }

  static String generateUniqueNumber() {
    final random = Random();
    int randomNumber = 100000 + random.nextInt(900000);
    return "$randomNumber";
  }

}
