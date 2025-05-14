import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../utils/widgets/CustomTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Login to your account!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Access your account to continue",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),

                      // Email
                      const SizedBox(height: 6),
                      CustomTextField(
                        labelText: "Email:",
                        hintText: "i.e., JohnSmith123@gmail.com",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Image.asset(
                          'assets/images/mail.png',
                          width: 14,
                          height: 14,
                        )
                      ),
                      const SizedBox(height: 5),
                      CustomTextField(
                        labelText: "Password",
                        hintText: "i.e., ************",
                        controller: _passwordController,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.text,
                        prefixIcon: Image.asset(
                          'assets/images/lock.png',
                          width: 14,
                          height: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            _obscureText
                                ? 'assets/images/eye.png' // Your closed eye icon
                                : 'assets/images/eye.png',  // Your open eye icon
                            width: 24, // Customize size if needed
                            height: 24, // Customize size if needed
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Forgot Password logic
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.BOTTOM_NAV);
                            Get.snackbar("Success", "Login successful",
                                backgroundColor: Colors.green, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHelper.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Bottom Sign-up Text
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SIGNUP);
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
