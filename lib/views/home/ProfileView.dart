import 'package:flutter/material.dart';

import '../../utils/color_helper.dart';
import '../../utils/widgets/CustomTextField.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController nameController =
      TextEditingController(text: "John Smith");
  final TextEditingController dobController =
      TextEditingController(text: "12/12/2002");
  final TextEditingController idController =
      TextEditingController(text: "456678");
  final TextEditingController phoneController =
      TextEditingController(text: "1223452334");
  final TextEditingController emailController =
      TextEditingController(text: "JohnSmith123@gmail.com");

  String selectedAffiliations = "Student, Veteran";

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2002, 12, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Avatar and Name
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      "assets/images/user.png"), // Replace with your own asset
                ),
                const SizedBox(height: 10),
                const Text("John Smith",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 1),
                const Text("Johnsmith12@gmail.com",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            // Name
            CustomTextField(
                labelText: '',
                hintText: 'John Smith',
                controller: nameController,
                bottomSpacing: 11),

            // DOB with icon
            CustomTextField(
              labelText: '',
              hintText: '12/12/2002',
              controller: dobController,
                bottomSpacing: 11,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),

            // Affiliations dropdown (not functional here)
            CustomTextField(
              labelText: '',
              hintText: selectedAffiliations,
                bottomSpacing: 11,
              controller: TextEditingController(text: selectedAffiliations),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),

            // ID
            CustomTextField(
              labelText: '',
              hintText: '456678',
              controller: idController,
                bottomSpacing: 11
            ),

            // Phone number (prefix icon example)
            CustomTextField(
              labelText: '',
              hintText: '1223452334',
              controller: phoneController,
                bottomSpacing: 11,
              prefixIcon: const Text("+1",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // Email
            CustomTextField(
              labelText: '',
              hintText: 'JohnSmith123@gmail.com',
              controller: emailController,
                bottomSpacing: 11,
              prefixIcon: const Icon(Icons.mail_outline),
            ),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
