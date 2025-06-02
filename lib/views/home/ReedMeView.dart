import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/home_controller.dart';
import '../../utils/color_helper.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;


class ReedMeView extends StatefulWidget {
  const ReedMeView({super.key});

  @override
  _ReedMeViewState createState() => _ReedMeViewState();
}

class _ReedMeViewState extends State<ReedMeView> {

  final box = GetStorage();

  List<Map<String, dynamic>> redeemedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRedeemedItems();

    final controller = Get.find<HomeController>();
    controller.redeemRefreshCallback = () {
      fetchRedeemedItems();
    };

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Redeemed",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : redeemedItems.isEmpty
          ? const Center(child: Text("No redeemed items found"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: redeemedItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = redeemedItems[index];
            final isNetworkImage = item['image'].toString().startsWith('http');

            return Container(
              decoration: BoxDecoration(
                color: ColorHelper.textFieldBGColor,
                border: Border.all(color: ColorHelper.textFieldBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorHelper.textFieldBorderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: isNetworkImage
                            ? Image.network(
                          item['image'],
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          item['image'],
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Promo Code: ",
                                  style: const TextStyle(fontSize: 11, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: item['promoCode'],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item['date'],
                                style: const TextStyle(fontSize: 11, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final redeemId = redeemedItems[index]['redeemId'];
                          deleteRedeemedItem(redeemId);

                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ColorHelper.textFieldBorderColor),
                        ),
                        child: Image.asset(
                          "assets/images/ic_delete.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }
  Future<void> fetchRedeemedItems() async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://promo.koderspoint.com/api/redeemed-item'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        setState(() {
          redeemedItems = data.map<Map<String, dynamic>>((entry) {
            final item = entry['items'][0];
            return {
              'redeemId': entry['id'],
              'title': item['title'] ?? '',
              'subtitle': item['description'] ?? '',
              'image': item['media'].isNotEmpty
                  ? item['media'][0]['original_url']
                  : 'assets/images/no_img.png',
              'promoCode': "XXXX", // Replace with actual promo code if exists
              'date': entry['created_at']?.split('T')[0] ?? '',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch redeemed items: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching redeemed items: $e");
      setState(() => isLoading = false);
    }
  }
  Future<void> deleteRedeemedItem(int redeemId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('https://promo.koderspoint.com/api/redeemed-item/destroy/$redeemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final message = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        await fetchRedeemedItems(); // refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete redeemed item')),
        );
      }
    } catch (e) {
      print("Error deleting redeemed item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Error deleting redeemed item: $e")),
      );
    }
  }

}
