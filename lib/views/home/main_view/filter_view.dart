import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:intl/intl.dart';

import '../../../utils/widgets/CustomTextField.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
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
  List<String> selectedCategories = [];


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
                        _buildCategoryChip("Accessories"),
                        _buildCategoryChip("Electronics"),
                        _buildCategoryChip("Cloth"),
                        _buildCategoryChip("Home Appliances"),
                        _buildCategoryChip("Furniture's"),
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
                        selectedCategories.clear();
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
                      // Apply logic here
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

  Widget _buildCategoryChip(String label) {
    final bool selected = selectedCategories.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            selectedCategories.remove(label);
          } else {
            selectedCategories.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: selected ? ColorHelper.blue : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? ColorHelper.blue : const Color(0xFFB3B3B3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFB3B3B3),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

}
