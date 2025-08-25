import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ui/services/api_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/app_pages.dart';
import '../../utils/color_helper.dart';
import '../../utils/widgets/custom_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Set<int> selectedAffiliationIndexes = {};

  List<String> selectedAffiliations = [];
  List<String> allAffiliations = [
    "Student",
    "Veteran",
    "Military",
    "Retired",
    "Non-Profit Worker",
    "Government Employee"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Up!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  labelText: "Full Name:",
                  hintText: "i.e., John Smith",
                  controller: _fullNameController,
                ),
                _buildDateField(),
                CustomTextField(
                  labelText: "Location (Zip Code):",
                  hintText: "i.e., 456678",
                  controller: _zipController,
                ),
                _buildDropdown(),
                const SizedBox(height: 5),
                CustomTextField(
                    labelText: "Email:",
                    hintText: "i.e., JohnSmith123@gmail.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Image.asset(
                      'assets/images/mail.png',
                      width: 14,
                      height: 14,
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  labelText: "Phone Number (optional):",
                  hintText: "i.e., +1223452334",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  labelText: "Password:",
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
                          ? 'assets/images/eye_on.png'
                          : 'assets/images/eye_off.png',
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
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // if (selectedAffiliationIndexes.isEmpty) {
                          //   Get.snackbar("Error", "Please select at least one affiliation");
                          //   return;
                          // }
                          checkZipCodeValidation();
                          print(_zipController.text);
                          await registerUser(
                            name: _fullNameController.text,
                            email: _emailController.text,
                            location: _zipController.text,
                            dob: _dobController.text,
                            password: _passwordController.text,
                            affiliationIds: selectedAffiliationIndexes.toList(),
                            phoneNumber: _phoneController.text,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.blue, strokeWidth: 2),
                        )
                      : const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          "Login",
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
        ),
      ),
    );
  }

  Future<void> checkZipCodeValidation() async {
    if (_emailController.text.isEmpty) {
      Get.snackbar("Error", "Email is required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (_zipController.text.isEmpty) {
      Get.snackbar("Error", "Zip Code is required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (_passwordController.text.isEmpty) {
      Get.snackbar("Error", "Password is required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    final url = Uri.parse('http://api.zippopotam.us/us/${_zipController.text}');
    final response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('places') &&
          data['places'] != null &&
          data['places'].isNotEmpty) {
        // Successfully fetched place data
        final place = data['places'][0];
        print("Place: ${place['place name']}, ${place['state']}");
      } else {
        Get.snackbar("Error", "Invalid Zip Code",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    } else {
      Get.snackbar("Error", "Invalid Zip Code",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        GestureDetector(
          child: CustomTextField(
            onTap: () => _selectDate(context),
            readOnly: true,
            labelText: "Date of Birth:",
            hintText: "i.e., 12/12/2002",
            controller: _dobController,
            suffixIcon: IconButton(
              icon: Image.asset(
                'assets/images/calendar.png',
                width: 20,
                height: 20,
              ),
              onPressed: null,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Affiliation Status:",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ColorHelper.dullBlack,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _showMultiSelectDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedAffiliations.isEmpty
                        ? "Select Status"
                        : selectedAffiliations.join(", "),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  child: Image.asset(
                    'assets/images/drop.png',
                    width: 15,
                    height: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    // Make a copy of current selection to pass to dialog
    final selected = Set<int>.from(selectedAffiliationIndexes);
    final selectedNames = List<String>.from(selectedAffiliations);

    final result = await showDialog<Set<int>>(
      context: context,
      barrierDismissible: true, // Allow dismiss on tapping outside
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "Select Affiliation",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...allAffiliations.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      bool isSelected = selected.contains(index);

                      return CheckboxListTile(
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: isSelected,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF30B0C7),
                        checkColor: Colors.white,
                        onChanged: (bool? checked) {
                          setStateDialog(() {
                            if (checked == true) {
                              selected.add(index);
                            } else {
                              selected.remove(index);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // Dialog dismissed: update parent state if result not null
    if (result != null) {
      setState(() {
        selectedAffiliationIndexes = result;
        selectedAffiliations =
            selectedAffiliationIndexes.map((i) => allAffiliations[i]).toList();
      });
    } else {
      // Dialog dismissed without explicit return, still update with temp selection
      setState(() {
        selectedAffiliationIndexes = selected;
        selectedAffiliations =
            selectedAffiliationIndexes.map((i) => allAffiliations[i]).toList();
      });
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String location,
    required String dob,
    required String password,
    required List<int> affiliationIds,
    required String phoneNumber,
  }) async {
    // if (affiliationIds.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please select at least one affiliation')),
    //   );
    //   return;
    // }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email')),
      );
      return;
    }

// Email validation using regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('$baseUrl/register');
      log(phoneNumber.toString());
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "location": location,
          "dob": dob,
          "password": password,
          "affiliation_id": affiliationIds,
          "phone_number": phoneNumber,
        }),
      );

      setState(() => _isLoading = false);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar("Success", data['message'] ?? "SignUp successful",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final errorMessage =
            data['message'] ?? data['error'] ?? 'Registration failed';
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar("Error", "Exception during register: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("❌ Exception during register: $e");
    }
  }
}
