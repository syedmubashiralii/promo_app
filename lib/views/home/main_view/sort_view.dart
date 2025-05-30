import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';

import '../../../utils/widgets/CustomTextField.dart';

class SortView extends StatefulWidget {
  const SortView({super.key});

  @override
  _SortViewState createState() => _SortViewState();
}

class _SortViewState extends State<SortView> {
  String? _selectedProximity;
  TextEditingController _selectedDateCon = TextEditingController();

  List<String> selectedAffiliations = [];
  List<String> allAffiliations = [
    "Student",
    "Veteran",
    "Military",
    "Retired",
    "Non-Profit Worker",
    "Government Employee"
  ];

  List<String> proximityOptions = [
    'Within 1 mile',
    'Within 15 miles',
    'Within 25 miles',
    'Within 35 miles',
    'Within 45 miles',
    'Within 55 miles',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text("Sort", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField(),
            const Text(
              "By Relevance:",
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
            const Text(
              "Proximity:",
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
                    _selectedProximity ?? "Select proximity",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  )),
                  GestureDetector(
                    onTap: () => _showSingleSelectDialog(context),
                    child: Image.asset(
                      'assets/images/drop.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedProximity = null;
                        _selectedDateCon.clear();
                        selectedAffiliations.clear();
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
                        'date': _selectedDateCon.text,
                        'status': selectedAffiliations,
                        'miles': _selectedProximity,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Apply Sort",
                        style: TextStyle(color: ColorHelper.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        CustomTextField(
          labelText: "By Date:",
          hintText: "i.e., 12/12/2002",
          controller: _selectedDateCon,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateCon.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSingleSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: proximityOptions.map((option) {
                    final isSelected = option == _selectedProximity;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedProximity = option;
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              isSelected
                                  ? 'assets/images/radio_selected.png'
                                  : 'assets/images/radio_unselected.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
