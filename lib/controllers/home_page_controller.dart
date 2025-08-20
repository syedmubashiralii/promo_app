import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ui/controllers/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_ui/models/items_model.dart';
import 'package:flutter_ui/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../views/home/main_view/sort_view.dart';

class HomePageController extends GetxController with WidgetsBindingObserver {
  final apiService = ApiService();
  final box = GetStorage();
  DateSortOrder selectedSortOrder = DateSortOrder.ascending;
  TextEditingController fromDateCon = TextEditingController();
  TextEditingController toDateCon = TextEditingController();
  String? selectedProximity;

  // State variables
  final categories = <String>[].obs;
  final selectedCategory = ''.obs;
  final selectedFilterCategory = ''.obs;
  final isLoadingCategories = true.obs;
  RxList<String> redeemedItemIds = <String>[].obs;

  final items = <ItemModel>[].obs;
  final filteredItems = <ItemModel>[].obs;
  final isLoading = true.obs;

  var searchQuery = ''.obs;
  final zipCode = ''.obs;
  LatLng? selectedLocation;
  final zipController = TextEditingController();
  final selectedAffiliations = <String>[].obs;

  // final favoriteStatus = <bool>[].obs;
  final favoritedItemIds = <int>{}.obs;

  final Map<String, int> statusIdMap = {
    "Student": 1,
    "Veteran": 2,
    "Military": 3,
    "Retired": 4,
    "Non-Profit Worker": 5,
    "Government Employee": 6,
  };

  final TextEditingController searchController = TextEditingController();

  final controller = Get.put(HomeController());
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchCategories();
    fetchItems();
    controller.homeRefreshCallback = () {
      updateFavoriteStatusOnly();
    };
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.onClose();
  }

  void onAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateFavoriteStatusOnly();
    }
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await apiService.fetchCategories();
      categories.assignAll(fetchedCategories);
      if (fetchedCategories.isNotEmpty) {
        selectedCategory.value = fetchedCategories[0];
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Fetch Items + Favorites
  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      final itemData = await apiService.fetchItems();
      items.assignAll(itemData);
      await _updateFavorites(itemData);
      filterItemsByCategory();
    } catch (e) {
      debugPrint("Error fetching items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateFavorites(List<ItemModel> itemData) async {
    final value = await apiService.fetchFavoriteList();
    final favIds = value
        .map<int>((fav) => int.tryParse(fav['item_id'].toString()) ?? -1)
        .where((id) => id != -1)
        .toSet();

    favoritedItemIds.value = favIds;
    // favoriteStatus.assignAll(itemData.map((item) => favIds.contains(item.id)));
  }

  void filterItemsByCategory() {
    List<ItemModel> result;

    if (selectedCategory.value == 'All') {
      result = items;
    } else {
      result = items.where((item) {
        final category = item.categories?.name?.toLowerCase() ?? '';
        return category == selectedCategory.value.toLowerCase();
      }).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result.where((item) {
        final title = item.title?.toLowerCase() ?? '';
        final description = item.description?.toLowerCase() ?? '';
        return title.contains(searchQuery.value) ||
            description.contains(searchQuery.value);
      }).toList();
    }

    filteredItems.assignAll(result);
  }

  Future filterItemsByAllConditions() async {
    if (selectedFilterCategory.value == '' && selectedAffiliations.isEmpty) {
      filteredItems.assignAll(items);
      return;
    }
    selectedCategory.value = selectedFilterCategory.value;

    if (selectedLocation == null) {
      // showSnackbar("Invalid ZIP code or location not found.");
      // return;
    }
    final result = items.where((item) {
      final category = item.categories?.name.toLowerCase() ?? '';

      LatLng itemLocation = LatLng(double.parse(item.latitude ?? '0.0'),
          double.parse(item.longitude ?? '0.0'));
      bool isNearby = false;
      if (selectedLocation != null) {
        isNearby = areLocationsNearby(selectedLocation!, itemLocation);
      }

      List<dynamic>? itemAffiliation = item.affiliationId?.toList() ?? [];

      final matchCategory = selectedFilterCategory.value == '' ||
          category == selectedFilterCategory.value.toLowerCase();

      final matchAffiliation = selectedAffiliations.isEmpty ||
          selectedAffiliations.any((status) {
            final statusId = statusIdMap[status].toString();
            final itemAffiliationList =
                itemAffiliation.map((e) => e.toString()).toList();

            return itemAffiliationList.contains(statusId);
          });

      return (matchCategory && matchAffiliation) &&
          (selectedLocation == null ? true : isNearby);
    }).toList();

    filteredItems.assignAll(result);
  }

  bool areLocationsNearby(LatLng loc1, LatLng loc2,
      {double thresholdInKm = 100.0}) {
    final lat1 = double.tryParse(loc1.latitude.toString()) ?? 0.0;
    final lon1 = double.tryParse(loc1.longitude.toString()) ?? 0.0;
    final lat2 = double.tryParse(loc2.latitude.toString()) ?? 0.0;
    final lon2 = double.tryParse(loc2.longitude.toString()) ?? 0.0;

    const R = 6371;

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = R * c;

    return distance <= thresholdInKm;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  Future<void> toggleFavorite(int index) async {
    final item = filteredItems[index];
    final itemId = item.id;

    if (favoritedItemIds.contains(itemId)) {
      showSnackbar("Item is already added in favorites");
      return;
    }

    final success = await apiService.storeFavorite(itemId);
    if (success) {
      // favoriteStatus[index] = true;
      favoritedItemIds.add(itemId);
      favoritedItemIds.refresh();
      showSnackbar("Added to favorites");

      updateFavoriteStatusOnly();
    } else {
      showSnackbar("Failed to update favorite");
    }
  }

  Future fetchRedeemedItemsList() async {
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
      redeemedItemIds.clear();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> redeemedItems = data['data'] ?? [];

        for (var entry in redeemedItems) {
          if (entry['item_id'] != null) {
            redeemedItemIds.add(entry['item_id'].toString());
          }
        }
      } else {
        print(
            'Failed to fetch redeemed items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching redeemed items: $e');
    }
  }

  Future<void> updateFavoriteStatusOnly() async {
    try {
      final favData = await apiService.fetchFavoriteList();
      final newIds = favData
          .map<int>((fav) => int.tryParse(fav['item_id'].toString()) ?? -1)
          .where((id) => id != -1)
          .toSet();

      favoritedItemIds.value = newIds;
      // favoriteStatus
      //     .assignAll(filteredItems.map((item) => favoritedItemIds.contains(item.id)));
    } catch (e) {
      debugPrint("Error updating favorite status: $e");
    }
  }

  Future<void> applySortFilters() async {
    int? miles = selectedProximity == null
        ? null
        : int.tryParse(
                selectedProximity?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ??
            0;

    List<ItemModel> result = items.where((item) {
      final category = item.categories?.name?.toLowerCase() ?? '';
      return category == selectedCategory.value.toLowerCase();
    }).toList();
    print(result.toList().toString());
    final List<ItemModel> filtered = [];

    double? userLat;
    double? userLng;
    if (miles != null) {
      EasyLoading.show(status: 'Applying Sort');
      final location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData? userLocation;

      try {
        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            showSnackbar("Location services are disabled.");
            return;
          }
        }

        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            showSnackbar("Location permission denied.");
            return;
          }
        }

        userLocation = await location.getLocation();
      } catch (e) {
        showSnackbar("Failed to get user location.");
        return;
      } finally {
        EasyLoading.dismiss();
      }

      userLat = userLocation.latitude;
      userLng = userLocation.longitude;

      if (userLat == null || userLng == null) {
        EasyLoading.dismiss();
        showSnackbar("Unable to retrieve location coordinates.");
        return;
      }
    }

    // Step 3: Parse from and to dates
    DateTime? from;
    DateTime? to;

    if (fromDateCon.text.isNotEmpty) {
      try {
        from = DateFormat('MM/dd/yyyy').parse(fromDateCon.text);
      } catch (_) {}
    }

    if (toDateCon.text.isNotEmpty) {
      try {
        to = DateFormat('MM/dd/yyyy').parse(toDateCon.text);
      } catch (_) {}
    }

    // Step 4: Apply filters
    for (var item in result) {
      final lat = double.tryParse(item.latitude ?? '');
      final lng = double.tryParse(item.longitude ?? '');
      debugPrint(
          "miles ${miles.toString()} lat${lat.toString()} lng ${lng.toString()}");

      if (miles != null && lat != null && lng != null) {
        final distance = calculateDistance(userLat!, userLng!, lat, lng);
        if (distance > miles) continue;
      }

      final itemDate = DateTime.tryParse(item.createdAt ?? '');
      if (itemDate == null) continue;

      if (from != null && itemDate.isBefore(from)) continue;
      if (to != null && itemDate.isAfter(to)) continue;

      filtered.add(item);
    }

    // Step 5: Sort by createdAt
    filtered.sort((a, b) {
      final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
      return selectedSortOrder == DateSortOrder.ascending
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });

    filteredItems.assignAll(filtered);
  }

  Future<Map<String, double>?> getLatLngFromZip(String zip) async {
    final url = Uri.parse('http://api.zippopotam.us/us/$zip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final place = data['places'][0];
      return {
        'lat': double.parse(place['latitude']),
        'lng': double.parse(place['longitude']),
      };
    } else {
      debugPrint("Failed to get location from ZIP");
      return null;
    }
  }

  Future addPerformance(int itemId, String type) async {
    final token = box.read('auth_token');
    print('adding Pefromance');
    if (token == null) return;

    try {
      final response =
          await http.post(Uri.parse('$baseUrl/performance/store'), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }, body: {
        "item_id": itemId.toString(),
        "type": type
      });

      print(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusMiles = 3958.8;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMiles * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  void showSnackbar(String message) {
    Get.snackbar('Info', message, snackPosition: SnackPosition.BOTTOM);
  }
}
