import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';

import '../../utils/widgets/CustomTextField.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  _ForgotViewState createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with icon-style text "Up"
              const Row(
                children: [
                  Text(
                    "Promo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorHelper.blue,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Forgot Password:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subtitle
              const Text(
                "We’ll guide you through the steps to create a new password and get you back on track in no time.",
                style: TextStyle(
                    fontSize: 15,
                    color: ColorHelper.textGrey,
                    height: 1.5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 25),

              // Label
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              CustomTextField(
                labelText: "",
                hintText: "i.e., JohnSmith123@gmail.com",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Get.offAllNamed(Routes.BOTTOM_NAV);
                    // Get.snackbar("Success", "Login successful",
                    //     backgroundColor: Colors.green, colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
