import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }
  void checkLoginStatus() {
    final token = box.read('auth_token');
    if (token != null && token.toString().isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/bottom_nav');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/freebee - logo.png',
                height: 200,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

}