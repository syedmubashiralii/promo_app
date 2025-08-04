import 'package:flutter/material.dart';
import 'package:flutter_ui/controllers/home_page_controller.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:flutter_ui/views/home/main_view/location_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/api_service.dart';
import '../../../utils/widgets/custom_text_field.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final ApiService apiService = ApiService();
  final HomePageController homePageController = Get.find<HomePageController>();

  final List<String> allAffiliations = [
    "Student",
    "Veteran",
    "Military",
    "Retired",
    "Non-Profit Worker",
    "Government Employee"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text("Filter", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      labelText: "Location (Lat Lng):",
                      hintText: "i.e., 33, 45",
                      showClear: true,
                      onPressed: () {
                        homePageController.zipController.text = '';
                        homePageController.selectedLocation = null;
                      },
                      readOnly: true,
                      controller: homePageController.zipController,
                      onTap: () async {
                        LatLng? selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );

                        if (selectedLocation != null) {
                          setState(() {
                            homePageController.selectedLocation =
                                selectedLocation;
                            homePageController.zipController.text =
                                '${selectedLocation.latitude}, ${selectedLocation.longitude}';
                          });
                        }
                      },
                      onChanged: (value) =>
                          homePageController.zipCode.value = value,
                    ),
                    const SizedBox(height: 16),
                    const Text("By Category",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Obx(() {
                      return SizedBox(
                        height: 40,
                        child: homePageController.isLoadingCategories.value
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: homePageController.categories.length,
                                itemBuilder: (_, index) {
                                  final category =
                                      homePageController.categories[index];
                                  final isSelected = category ==
                                      homePageController
                                          .selectedFilterCategory.value;

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
                                        homePageController
                                            .selectedFilterCategory
                                            .value = category;
                                        setState(() {});
                                      },
                                      showCheckmark: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildAffiliationDropdown(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        homePageController.zipController.clear();
                        homePageController.selectedAffiliations.clear();
                        homePageController.selectedFilterCategory.value = "";
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHelper.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Reset",
                          style: TextStyle(color: ColorHelper.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                     
                        Navigator.pop(context, {
                          'zipCode':
                              homePageController.zipController.text.trim(),
                          'selectedCategory':
                              homePageController.selectedFilterCategory.value,
                          'selectedAffiliations':
                              homePageController.selectedAffiliations.value,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHelper.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Apply Filter",
                          style: TextStyle(color: ColorHelper.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAffiliationDropdown() {
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
                    homePageController.selectedAffiliations.isEmpty
                        ? "Select status"
                        : homePageController.selectedAffiliations.join(", "),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset('assets/images/drop.png', width: 15, height: 15),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _showMultiSelectDialog(BuildContext context) {
    List<String> tempSelections =
        List.from(homePageController.selectedAffiliations);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Affiliation(s)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...allAffiliations.map((item) {
                      final isSelected = tempSelections.contains(item);
                      return CheckboxListTile(
                        title: Text(item,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        value: isSelected,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: ColorHelper.blue,
                        checkColor: Colors.white,
                        onChanged: (bool? selected) {
                          setStateDialog(() {
                            if (selected == true) {
                              tempSelections.add(item);
                            } else {
                              tempSelections.remove(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: ColorHelper.dullBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHelper.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              homePageController.selectedAffiliations
                                ..clear()
                                ..addAll(tempSelections);
                            });

                            Navigator.pop(context);
                          },
                          child: const Text("OK",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
