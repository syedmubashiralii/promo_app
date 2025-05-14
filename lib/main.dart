import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui/routes/app_pages.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Promo App",
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes
    );
  }
}
