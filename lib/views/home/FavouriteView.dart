import 'package:flutter/material.dart';

import '../../utils/color_helper.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  // Dummy favorite list
  final List<Map<String, String>> favoriteItems = [
    {
      'title': "Fossil Men's Quartz",
      'subtitle': "From an inky matte dial to...",
      'image': 'assets/images/watch.png',
    },
    // Add more items if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorite",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: favoriteItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = favoriteItems[index];
            return Container(
              decoration: BoxDecoration(
                color: ColorHelper.textFieldBGColor,
                border: Border.all(color: ColorHelper.textFieldBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                leading: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  // Padding for the border space
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorHelper.textFieldBorderColor),
                    // Light grey border
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      item['image']!,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  item['subtitle']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      favoriteItems.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: ColorHelper.textFieldBorderColor),
                    ),
                    child: Image.asset(
                      "assets/images/ic_delete.png",
                      height: 22,
                      width: 22, // Replace with your own asset
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
