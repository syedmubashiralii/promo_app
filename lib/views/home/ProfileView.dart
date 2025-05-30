import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../routes/app_pages.dart';
import '../../utils/color_helper.dart';
import '../../utils/widgets/CustomTextField.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final box = GetStorage();

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
  String profileName = "";
  String profileEmail = "";

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

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  File? _imageFile;

  bool _isLoading = true;
  bool isEditMode = false;

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
  void initState() {
    super.initState();
    fetchProfile();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        profileName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profileEmail,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/edit.png',
                          width: 22,
                          height: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            isEditMode = !isEditMode;
                          });
                        },
                      ),
                    ],
                  ),


                  const SizedBox(height: 10),
                  CustomTextField(
                      labelText: '',
                      hintText: 'Enter Name',
                      controller: nameController,
                      bottomSpacing: 11),

                  // DOB with icon
                  CustomTextField(
                    labelText: '',
                    hintText: 'Date of Birth',
                    controller: dobController,
                    bottomSpacing: 11,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),

                  InkWell(
                    onTap: () => _showSingleSelectDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        border:
                            Border.all(color: const Color(0xFFE1E1E1), width: 1),
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

                  const SizedBox(height: 10),
                  // ID
                  CustomTextField(
                      labelText: '',
                      hintText: 'ID',
                      controller: idController,
                      bottomSpacing: 11),

                  CustomTextField(
                    labelText: '',
                    hintText: 'Phone number ',
                    controller: phoneController,
                    bottomSpacing: 11,
                    // prefixIcon: const Text("+1",
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                  ),

                  // Email
                  CustomTextField(
                    labelText: '',
                    hintText: 'Enter Email',
                    controller: emailController,
                    bottomSpacing: 11,
                    prefixIcon: const Icon(Icons.mail_outline),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isEditMode ? ColorHelper.blue : ColorHelper.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (isEditMode) {
                          updateProfile();
                          print("Updating profile...");
                          setState(() {
                            isEditMode = false;
                          });
                        } else {
                          box.remove('auth_token');
                          Get.offAllNamed(Routes.LOGIN);
                        }
                      },
                      child: Text(
                        isEditMode ? "Update Profile" : "Log Out",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showSingleSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                ...allAffiliations.asMap().entries.map((entry) {
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

  void fetchProfile() async {
    final token = box.read('auth_token');
    print("token found $token");

    if (token != null && token.toString().isNotEmpty) {
      if (token == null) {
        print("No token found");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://promo.koderspoint.com/api/user-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("200");
        final responseData = json.decode(response.body);
        final user = responseData['data'][0];
        print("responseData $responseData" );
        print("user $user" );

        setState(() {
          nameController.text = user['name'] ?? '';
          dobController.text = user['dob'] ?? '';
          idController.text = user['id'].toString();
          phoneController.text = user['phone_number'] ?? '';
          emailController.text = user['email'] ?? '';
          selectedAffiliationIndex = int.tryParse(user['affiliation_id'].toString());
          if (selectedAffiliationIndex != null &&
              selectedAffiliationIndex! < allAffiliations.length) {
            selectedAffiliationName = allAffiliations[selectedAffiliationIndex!];
          }


          profileName = user['name'] ?? '';
          profileEmail = user['email'] ?? '';

          _isLoading = false;
        });
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    final token = box.read('auth_token');
    final uri =
        Uri.parse('https://promo.koderspoint.com/api/user-profile/update');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['name'] = nameController.text;
    // request.fields['email'] = emailController.text;
    request.fields['location'] = dobController.text;
    request.fields['dob'] = dobController.text;
    request.fields['affiliation_id'] =
        selectedAffiliationIndex?.toString() ?? '';
    request.fields['phone_number'] = phoneController.text;
/*
    if (_imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }*/

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        isEditMode = false; // Exit edit mode
      });

      fetchProfile(); // Reload profile data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
