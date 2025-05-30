import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:get_storage/get_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await Hive.initFlutter();
  // await Hive.openBox('authBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "FreeBee",
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes
    );
  }
}
