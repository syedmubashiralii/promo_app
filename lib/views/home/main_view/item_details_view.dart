import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ui/controllers/home_page_controller.dart';
import 'package:flutter_ui/models/items_model.dart';
import 'package:flutter_ui/services/api_service.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../report_view.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({super.key});

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  late final ItemModel item;
  Set<int> redeemedItemIds = {};
  int _currentImageIndex = 0;
  HomePageController homePageController = Get.find();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is ItemModel) {
      item = args;
    } else {
      // Handle the case where no valid arguments are passed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No item data provided.')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.media != null && item.media!.isNotEmpty
        ? item.media![0].originalUrl
        : null;

    bool redeemed =
        homePageController.redeemedItemIds.contains(item.id.toString());

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Item Details',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Stack(
                      children: [_buildImageSlider()],
                    ),
                    const SizedBox(height: 8),

                    // Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          item.isFree == 1 ? 'Free' : "\$${item.price}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoPill(
                          label: "Status",
                          value: item.status ?? 'N/A',
                          backgroundColor: const Color(0xFFEBDDF9),
                        ),
                        _buildInfoPill(
                          label: "Affiliation",
                          value: item.affiliationId.toString(),
                          backgroundColor: const Color(0xFFFFDDE1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Builder(builder: (context) {
                      bool isIndividual = item.businessType == 'individual' ||
                          item.businessType == null;
                      return GestureDetector(
                        onTap: () {
                          if (!isIndividual) {
                            final Uri _url = Uri.parse(item.locationUrl ?? "");
                            _launchUrl(_url);
                          }
                        },
                        child: _buildInfoPill(
                          width: Get.width,
                          label: isIndividual ? "Location" : "Location Url",
                          value: isIndividual
                              ? item.location ?? "N/A"
                              : item.locationUrl ?? 'N/A',
                          backgroundColor: const Color(0xFFD4E8FF),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    const Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description ?? '',
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Redemption Instructions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    BulletList([
                      item.redemptionInstruction ?? 'Not available',
                    ]),

                    const SizedBox(height: 24),
                    const Text(
                      "Eligibility Criteria",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    BulletList([
                      item.eligibilityCriteria ?? 'Not available',
                    ]),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.to(() => const ReportView());
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Report",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: redeemed
                          ? null
                          : () {
                              final int itemId = item.id;
                              mStoreRedeemItem(itemId);
                              homePageController.redeemedItemIds
                                  .add(itemId.toString());
                              homePageController.redeemedItemIds.refresh();
                              setState(() {});
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            redeemed ? ColorHelper.dullBlack : ColorHelper.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Redeem Now",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        _shareItem(item);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Share",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _shareItem(ItemModel item) {
    final title = item.title ?? 'Awesome Freebie';
    const businessName = ' Business';
    final description = item.description ?? '';
    final redemption =
        item.redemptionInstruction ?? 'See details in the FreeBee app.';
    final locationUrl =
        item.businessType == 'individual' || item.businessType == null
            ? item.location
            : item.locationUrl ??
                'https://freebecause.com'; // fallback if not available
    const applink =
        'https://play.google.com/store/apps/details?id=com.freebee.app';

    final shareMessage = '''
Hey! Check this out: *$title* from $businessName!
$description

How to redeem: $redemption
Find location or redeem here: $locationUrl

🎁 Download the FreeBee app to unlock this and other free deals!
Found this on FreeBee – your app for personalized freebies!
$applink

''';

    SharePlus.instance.share(ShareParams(text: shareMessage.trim()));
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _buildImageSlider() {
    final List<PromoMedia> mediaList = item.media ?? [];

    if (mediaList.isEmpty) {
      return Container(
        height: 170,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No image',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = mediaList[index].originalUrl;
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Text('No image')),
              ),
            );
          },
          options: CarouselOptions(
            height: 170,
            viewportFraction: 1,
            enableInfiniteScroll: mediaList.length > 1,
            autoPlay: mediaList.length > 1,
            scrollPhysics: mediaList.length > 1
                ? null
                : const NeverScrollableScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mediaList.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                Icons.circle,
                size: 8,
                color: _currentImageIndex == index
                    ? ColorHelper.blue
                    : const Color(0xffECECEC),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoPill({
    required String label,
    double? width,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      width: width ?? 100,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> mStoreRedeemItem(int itemId) async {
    final box = GetStorage();
    final token = box.read('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    /* if (redeemedItemIds.contains(itemId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item is already redeemed")),
      );
      return;
    }*/

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/redeemed-item/store'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"item_id": itemId}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('data $jsonData');

        final message = jsonData['message'];
        final error = jsonData['error'];

        final displayText = error ?? message ?? 'Unknown response';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayText)),
        );
      }
    } catch (e) {
      print("Redeem error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> fetchRedeemedItems() async {
    final box = GetStorage();
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/redeemed-item'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        redeemedItemIds = data
            .where(
                (entry) => entry['items'] != null && entry['items'].isNotEmpty)
            .map<int>((entry) => entry['items'][0]['id'])
            .toSet();
      } else {
        print('Failed to fetch redeemed items: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching redeemed items: $e");
    }
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ",
                        style: TextStyle(
                            fontSize: 14, height: 1.4, color: Colors.grey)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14, height: 1.4, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
