import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/color_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());
  final box = GetStorage();

  // final List<String> categories = [
  //   'All',
  //   'Accessories',
  //   'Electronics',
  //   'Cloth',
  //   'Home'
  // ];
  // String selectedCategory = 'All';

  List<String> categories = [];
  String selectedCategory = '';
  bool _isLoadingCategories = true;

//comment edit
  List<bool> favoriteStatus = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Home",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Icons
            Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE1E1E1)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search items',
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/search.png',
                          width: 18,
                          height: 18,
                          color: const Color(0xFFB3B3B3),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Sort Icon Button
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E1E1)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      'assets/images/sort.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.SORTVIEW);
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Filter Icon Button
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E1E1)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      'assets/images/filter.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.FILTERVIEW);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories
            const Text("Categories",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _isLoadingCategories
                ? const CircularProgressIndicator()
            : SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  String category = categories[index];
                  bool isSelected = category == selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFB3B3B3),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: ColorHelper.blue,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? ColorHelper.blue
                            : const Color(0xFFB3B3B3),
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Free Items Label
            const Text("Free Items",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                // childAspectRatio: 0.9,
              ),
              itemBuilder: (_, index) {
                return SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE1E1E1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // Ensures content-based height
                      children: [
                        // Image + Favorite Icon
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Image.asset(
                                  'assets/images/watch.png',
                                  height: 70,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    favoriteStatus[index] =
                                        !favoriteStatus[index];
                                  });
                                },
                                child: Icon(
                                  favoriteStatus[index]
                                      ? Icons.favorite // filled
                                      : Icons.favorite_border, // outline
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Info
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Fossil Men's Quartz",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "Free",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Text(
                                "From an Italy matte dial to brushed jet...",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // View Details Button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          child: SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorHelper.blue,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.VIEWDETAIL);
                              },
                              child: const Text(
                                "View Details",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void fetchCategories() async {
    final token = box.read('auth_token');
    if (token == null || token.toString().isEmpty) {
      print("No token found");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://promo.koderspoint.com/api/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> categoryData = responseData['data'];

        setState(() {
          categories = categoryData.map((e) => e['name'].toString()).toList();
          if (categories.isNotEmpty) {
            selectedCategory = categories[0];
          }
          _isLoadingCategories = false;
        });
      } else {
        print("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }
}
