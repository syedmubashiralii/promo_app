import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ui/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ui/utils/color_helper.dart';
import '../../utils/widgets/custom_text_field.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  _ForgotViewState createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool otpSent = false;
  bool isLoading = false;

  Future<void> sendOtp() async {
    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/otp/send');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailController.text.trim()}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        otpSent = true;
      });
      showSnackBar("OTP Send successfully on your mail");
    } else {
      showSnackBar(data['message'] ?? "Failed to send OTP", isError: true);
    }
    setState(() => isLoading = false);
  }

  Future<void> resetPassword() async {
    setState(() => isLoading = true);
    final url = Uri.parse('$baseUrl/password/reset');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp': otpController.text.trim(),
        'password': newPasswordController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      showSnackBar(data['message']);
      Navigator.pop(context); // Or navigate to login screen
    } else {
      showSnackBar(data['message'] ?? "Password reset failed", isError: true);
    }
    setState(() => isLoading = false);
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 32,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const Text(
                    "We’ll guide you through the steps to create a new password and get you back on track in no time.",
                    style: TextStyle(
                        fontSize: 15,
                        color: ColorHelper.textGrey,
                        height: 1.5,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: "",
                    hintText: "i.e., JohnSmith123@gmail.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !otpSent,
                  ),
                  const SizedBox(height: 16),
                  if (otpSent) ...[
                    const Text("OTP"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      labelText: "",
                      hintText: "Enter OTP",
                      controller: otpController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Text("New Password"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      labelText: "",
                      hintText: "Enter new password",
                      controller: newPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!otpSent) {
                                sendOtp();
                              } else {
                                resetPassword();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHelper.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        isLoading
                            ? "Please wait..."
                            : otpSent
                                ? "Reset Password"
                                : "Send OTP",
                        style: const TextStyle(
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
        ),
      ),
    );
  }
}
