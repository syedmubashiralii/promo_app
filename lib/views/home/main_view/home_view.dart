import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../ApiService/api_service.dart';
import '../../../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/color_helper.dart';
import 'filter_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final ApiService apiService = ApiService();

  final controller = Get.put(HomeController());
  final box = GetStorage();

  List<String> categories = [];
  String selectedCategory = '';
  bool _isLoadingCategories = true;

  List<bool> favoriteStatus = [];
  Set<int> favoritedItemIds = {};
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool isLoading = true;

  String zipCode = '';
  List<String> selectedAffiliations = [];
  final Map<String, int> statusIdMap = {
    "Student": 1,
    "Veteran": 2,
    "Military": 3,
    "Retired": 4,
    "Non-Profit Worker": 5,
    "Government Employee": 6,
  };

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    fetchCategories();
    fetchItems();

    controller.homeRefreshCallback = () {
      fetchItems();
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchItems(); // Refresh favorites on resume
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Home",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Icons
            Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE1E1E1)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.toLowerCase();
                                filterItemsByCategory();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search items',
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/search.png',
                          width: 18,
                          height: 18,
                          color: const Color(0xFFB3B3B3),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Sort Icon Button
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E1E1)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      'assets/images/sort.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.SORTVIEW);
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Filter Icon Button
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E1E1)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      'assets/images/filter.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () async {

                      // Get.toNamed(Routes.FILTERVIEW);

                      final result = await Get.to(() => const FilterView());

                      if (result != null && result is Map) {
                        final zipCode = result['zipCode'] ?? '';
                        final selectedCategory = result['selectedCategory'] ?? 'All';
                        final List<String> selectedAffiliations = List<String>.from(result['selectedAffiliations'] ?? []);

                        setState(() {
                          this.selectedCategory = selectedCategory;
                          this.zipCode = zipCode; // Define `zipCode` in your state
                          this.selectedAffiliations = selectedAffiliations; // Define it too
                        });

                        filterItemsByAllConditions();
                      }

                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Categories
            const Text("Categories",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
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
                                filterItemsByCategory();
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

            const SizedBox(height: 20),

            // Free Items Label
            const Text("Free Items",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) {
                      final item = filteredItems[index];
                      final mediaList = item['media'] ?? [];
                      final imageUrl = (mediaList.isNotEmpty &&
                              mediaList[0]['original_url'] != null &&
                              mediaList[0]['original_url']
                                  .toString()
                                  .isNotEmpty)
                          ? mediaList[0]['original_url']
                          : null;
                      final title = item['title'] ?? '';
                      final description = item['description'] ?? '';
                      final price =
                          item['is_free'] == 1 ? 'Free' : '\$${item['price']}';

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE1E1E1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image and favorite icon
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl,
                                            height: 70,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/no_img.png',
                                            height: 70,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => toggleFavorite(index),
                                    child: Icon(
                                      favoriteStatus[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Title & Description
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        price,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    description,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // View Details
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              child: SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorHelper.blue,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.toNamed(Routes.VIEWDETAIL,
                                        arguments: item);
                                  },
                                  child: Text(
                                    "View Details",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
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

  void fetchItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final itemData = await apiService.fetchItems();
      final favData = await apiService.fetchFavoriteList();

      favoritedItemIds = favData.map<int>((fav) => fav['item_id']).toSet();

      setState(() {
        items = itemData;
        favoriteStatus = itemData
            .map<bool>((item) => favoritedItemIds.contains(item['id']))
            .toList();
        filterItemsByCategory();
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      showSnackbar("Error occurred");
      setState(() => isLoading = false);
    }
  }
  void filterItemsByCategory() {
    if (selectedCategory == 'All') {
      filteredItems = items;
    } else {
      filteredItems = items.where((item) {
        final category = item['categories'];
        return category != null &&
            category['name']?.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        final title = item['title']?.toLowerCase() ?? '';
        final description = item['description']?.toLowerCase() ?? '';
        return title.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    }

  }

  void filterItemsByAllConditions() {
    filteredItems = items.where((item) {
      final category = item['categories']?['name']?.toLowerCase() ?? '';
      final itemZip = item['location']?.toLowerCase() ?? '';
      final itemAffiliation = item['affiliation_id']?.toString();

      final matchCategory = selectedCategory == 'All' || category == selectedCategory.toLowerCase();
      final matchZip = zipCode.isEmpty || itemZip.contains(zipCode.toLowerCase());
      final matchAffiliation = selectedAffiliations.isEmpty ||
          selectedAffiliations.any((status) {
            return statusIdMap[status].toString() == itemAffiliation;
          });

      return matchCategory && matchZip && matchAffiliation;
    }).toList();

    setState(() {});
  }

  void toggleFavorite(int index) async {
    final itemId = items[index]['id'];
    final success = await apiService.storeFavorite(itemId);

    if (success) {
      setState(() {
        favoriteStatus[index] = !favoriteStatus[index];
      });
    } else {
      showSnackbar("Failed to update favorite");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
