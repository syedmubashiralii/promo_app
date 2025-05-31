import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:intl/intl.dart';

import '../../../ApiService/api_service.dart';
import '../../../utils/widgets/CustomTextField.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final ApiService apiService = ApiService();

  TextEditingController _selectedDateCon = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  List<String> selectedAffiliations = [];
  List<String> allAffiliations = [
    "Student",
    "Veteran",
    "Military",
    "Retired",
    "Non-Profit Worker",
    "Government Employee"
  ];
  List<String> categories = [];
  String selectedCategory = '';
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text("Filter", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location (Zip Code)
                    CustomTextField(
                      labelText: "Location (Zip Code):",
                      hintText: "i.e., 456678",
                      controller: _zipController,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "By Category",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Buttons pinned to the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _zipController.clear();
                        _selectedDateCon.clear();
                        selectedAffiliations.clear();
                        selectedCategory="";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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
                        'zipCode': _zipController.text.trim(),
                        'selectedCategory': selectedCategory,
                        'selectedAffiliations': selectedAffiliations,
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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
    );
  }

  Widget _buildDropdown() {
    return GestureDetector(
      child: Column(
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
                          ? "Select status"
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
      ),
    );
  }
  void _showMultiSelectDialog(BuildContext context) {
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
                  // ⬅ Only left padding
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
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    // ⬅ Less vertical spacing
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



  void fetchCategories() async {
    try {
      final fetchedCategories = await apiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        if (categories.isNotEmpty) {
          selectedCategory = categories[0];
        }
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }
}
