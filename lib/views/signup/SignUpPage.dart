import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final TextEditingController _passwordController = TextEditingController();

  String _affiliationStatus = 'Student';
  final List<String> _affiliationOptions = ['Student', 'Teacher', 'Other'];
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
                const Center(
                  child: Text(
                    "Sign Up!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
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
                    )),
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
                          : 'assets/images/eye.png', // Your open eye icon
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () {
                    // Signup logic
                    Get.offAllNamed(Routes.LOGIN);
                    Get.snackbar("Success", "SignUp successful",
                        backgroundColor: Colors.green,
                        colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text("Sign Up",
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
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: const Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
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

  Widget _buildTextField(String label, String hint,
      TextEditingController controller,
      {bool isPassword = false,
        TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          labelText: label,
          hintText: hint,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? _obscureText : false,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
        const SizedBox(height: 15),
      ],
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
        Container(
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
                      ? "Select status"
                      : selectedAffiliations.join(", "),
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => _showMultiSelectDialog(context),
                child: Image.asset(
                  'assets/images/drop.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _showMultiSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10), // ⬅ Only left padding
                  child: Text(
                    "Select",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ...allAffiliations.map((item) {
                  bool isSelected = selectedAffiliations.contains(item);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0), // ⬅ Less vertical spacing
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: const Color(0xFF355F9B),
                      ),
                      child: CheckboxListTile(
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
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedAffiliations.add(item);
                            } else {
                              selectedAffiliations.remove(item);
                            }
                          });
                          Navigator.pop(context);
                          _showMultiSelectDialog(context);
                        },
                        checkColor: Colors.white,
                        activeColor: const Color(0xFF30B0C7),
                      ),
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
}