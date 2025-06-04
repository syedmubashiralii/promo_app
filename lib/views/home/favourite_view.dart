import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';
import '../../controllers/home_controller.dart';
import '../../utils/color_helper.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  final ApiService apiService = ApiService();

  List<Map<String, dynamic>> favoriteItems = [];
  bool isLoading = true;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchFavoriteItems();

    final controller = Get.find<HomeController>();
    controller.favRefreshCallback = () {
      refreshFavoriteItemsIfChanged();
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
          "Favorite",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: favoriteItems.isEmpty
                  ? const Center(child: Text("No favorites found"))
                  : ListView.separated(
                      itemCount: favoriteItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final item = favoriteItems[index];
                        final isNetworkImage =
                            item['image'].toString().startsWith('http');

                        return Container(
                          key: ValueKey(item['favId']),
                          decoration: BoxDecoration(
                            color: ColorHelper.textFieldBGColor,
                            border: Border.all(
                                color: ColorHelper.textFieldBorderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 1),
                            leading: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorHelper.textFieldBorderColor),
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
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              item['subtitle'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: GestureDetector(
                             /* onTap: () {
                                setState(() {
                                  final favId = favoriteItems[index]['favId'];
                                  deleteFavoriteItem(favId, index);
                                });
                              },*/
                              onTap: () => deleteFavoriteItem(item['favId'], index),

                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: ColorHelper.textFieldBorderColor),
                                ),
                                child: Image.asset(
                                  "assets/images/ic_delete.png",
                                  height: 22,
                                  width: 22,
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
  Future<void> fetchFavoriteItems() async {
    setState(() => isLoading = true);
    try {
      final items = await apiService.fetchFavoriteItems();
      setState(() {
        favoriteItems = items;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load favorites')),
      );
    }
  }
  Future<void> deleteFavoriteItem(int favId, int index) async {
    final success = await apiService.deleteFavoriteItem(favId);
    if (success) {
      // setState(() {
      //   favoriteItems.removeAt(index);
      // });
      favoriteItems.removeAt(index);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favorite item deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete favorite item')),
      );
    }
  }

  void refreshFavoriteItemsIfChanged() async {
    try {
      final newItems = await apiService.fetchFavoriteItems();

      final newUniqueItems = newItems.where((newItem) {
        return !favoriteItems.any((existingItem) => existingItem['favId'] == newItem['favId']);
      }).toList();

      if (newUniqueItems.isNotEmpty) {
        setState(() {
          favoriteItems.insertAll(0, newUniqueItems);
        });
      }
    } catch (_) {
      // Optional: show an error
      debugPrint('Failed to refresh new favorites');
    }
  }

}
