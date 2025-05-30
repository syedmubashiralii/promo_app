import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/app_pages.dart';
import '../../utils/color_helper.dart';
import '../../utils/widgets/CustomTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String selectedAffiliationName = "Select Status";
  int? selectedAffiliationIndex;

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
                onPressed: _isLoading ? null :  () async {
                  if(selectedAffiliationIndex==null){
                    Get.snackbar("Error", "Please Select Affliation Status");
                    return;
                  }
                  await registerUser(
                    name: _fullNameController.text,
                    email: _emailController.text,
                    location: _zipController.text,
                    dob: _dobController.text,
                    password: _passwordController.text,
                    affiliationId: selectedAffiliationIndex,
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
                    : const Text(
                    "Sign Up",
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
    ),)
    ,
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        CustomTextField(
          labelText: "Date of Birth:",
          hintText: "i.e., 12/12/2002",
          controller: _dobController,
          suffixIcon: IconButton(
            icon: Image.asset(
              'assets/images/calendar.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => _selectDate(context),
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
            onTap: () => _showSingleSelectDialog(context),
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
                    selectedAffiliationName,
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

  void _showSingleSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
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
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ...allAffiliations
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  bool isSelected = selectedAffiliationIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selectedAffiliationIndex,
                      title: Text(
                        item,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      activeColor: const Color(0xFF30B0C7),
                      onChanged: (int? value) {
                        setState(() {
                          selectedAffiliationIndex = value;
                          selectedAffiliationName = allAffiliations[value!];
                        });
                        Navigator.pop(context);
                      },

                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String location,
    required String dob,
    required String password,
    required int? affiliationId,
    required String phoneNumber,
  }) async {
    if (selectedAffiliationIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your affiliation')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://promo.koderspoint.com/api/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "location": location,
          "dob": dob,
          "password": password,
          "affiliation_id": affiliationId,
          "phone_number": phoneNumber,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          print("✅ User created successfully");
          print("Token: ${data['data']['token']}");

          Get.offAllNamed(Routes.LOGIN);
          Get.snackbar("Success", "SignUp successful",
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          print("❌ Registration failed: ${data['message']}");
          Get.snackbar("Error", data['message'],
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        Get.snackbar("Error", "Server error (${response.statusCode})",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("❌ Exception: $e");
      Get.snackbar("Error", "Something went wrong!",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


}
