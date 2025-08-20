import 'package:flutter/material.dart';
import 'package:flutter_ui/controllers/home_page_controller.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum DateSortOrder { ascending, descending }

class SortView extends StatefulWidget {
  const SortView({super.key});

  @override
  _SortViewState createState() => _SortViewState();
}

class _SortViewState extends State<SortView> {
  final HomePageController homePageController = Get.find<HomePageController>();

  


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
        leading: const BackButton(color: Colors.black),
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
            _buildDateSortOptions(),
            const SizedBox(height: 15),
            _buildDateRangeFields(),
            const SizedBox(height: 15),
            _buildProximityPicker(context),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        homePageController.selectedProximity = null;
                        homePageController.fromDateCon.clear();
                        homePageController.toDateCon.clear();
                      });
                      Navigator.pop(context);
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
                      final from = homePageController.fromDateCon.text.trim();
                      final to = homePageController.toDateCon.text.trim();

                      if ((from.isNotEmpty && to.isEmpty) ||
                          (to.isNotEmpty && from.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please select both 'From' and 'To' dates."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      

                      Navigator.pop(context, {
                        'from': from,
                        'to': to,
                        'miles': homePageController.selectedProximity,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildDateSortOptions() {
    return Row(
      children: [
        const Text("Sort by Date: "),
        Row(
          children: [
            Radio<DateSortOrder>(
              value: DateSortOrder.ascending,
              groupValue: homePageController.selectedSortOrder,
              onChanged: (value) {
                setState(() {
                  homePageController.selectedSortOrder = value!;
                });
              },
            ),
            const Text('Ascending'),
          ],
        ),
        Row(
          children: [
            Radio<DateSortOrder>(
              value: DateSortOrder.descending,
              groupValue: homePageController.selectedSortOrder,
              onChanged: (value) {
                setState(() {
                  homePageController.selectedSortOrder = value!;
                });
              },
            ),
            const Text('Descending'),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeFields() {
    return Row(
      children: [
        Expanded(
          child: _buildDatePickerField(
            label: 'From:',
            controller: homePageController.fromDateCon,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDatePickerField(
            label: 'To:',
            controller: homePageController.toDateCon,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _selectDate(controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'Select date' : controller.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Image.asset(
                  'assets/images/calendar.png',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProximityPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Proximity:",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: ColorHelper.dullBlack)),
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
                    homePageController.selectedProximity ?? "Select proximity",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  'assets/images/drop.png',
                  width: 15,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
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
                    final isSelected = option == homePageController.selectedProximity;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          homePageController.selectedProximity = option;
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
