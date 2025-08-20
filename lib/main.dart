import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ui/firebase_options.dart';
import 'package:flutter_ui/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:hive_flutter/adapters.dart';
// import 'package:get_storage/get_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        builder: EasyLoading.init(),
        getPages: AppPages.routes);
  }
}
