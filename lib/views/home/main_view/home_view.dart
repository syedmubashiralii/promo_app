import 'package:flutter/material.dart';
import 'package:flutter_ui/controllers/home_page_controller.dart';
import 'package:flutter_ui/models/items_model.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/color_helper.dart';
import 'filter_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePageController.fetchRedeemedItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchAndFilterRow(),
              const SizedBox(height: 20),
              _buildCategorySection(),
              const SizedBox(height: 20),
              _buildItemsSection(),
            ],
          ),
        );
      }),
      floatingActionButton: Container(
        height: 40,
        width: 40,
        child: InkWell(
          onTap: () async {
            homePageController.selectedFilterCategory.value = '';
            homePageController.selectedAffiliations.clear();
            homePageController.zipCode.value = '';
            homePageController.zipController.clear();
            homePageController.searchController.clear();
            homePageController.searchQuery.value = '';
            homePageController.filteredItems
                .assignAll(homePageController.items);
            homePageController.fetchRedeemedItemsList();
            homePageController.fetchCategories();
            homePageController.fetchItems();
            homePageController.updateFavoriteStatusOnly();
          },
          child: CircleAvatar(
            backgroundColor: ColorHelper.blue,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorHelper.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Home",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        // Search Bar
        Expanded(child: _buildSearchBar()),
        const SizedBox(width: 8),
        _buildIconButton('assets/images/sort.png', _onSortPressed),
        const SizedBox(width: 8),
        _buildIconButton('assets/images/filter.png', _onFilterPressed),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
              controller: homePageController.searchController,
              onChanged: (value) {
                setState(() {
                  homePageController.searchQuery.value = value.toLowerCase();
                  homePageController.filterItemsByCategory();
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
          Image.asset('assets/images/search.png',
              width: 18, height: 18, color: const Color(0xFFB3B3B3)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Image.asset(assetPath, width: 20, height: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categories", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        homePageController.isLoadingCategories.value
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homePageController.categories.length,
                  itemBuilder: (_, index) {
                    final category = homePageController.categories[index];
                    final isSelected =
                        category == homePageController.selectedCategory.value;
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
                            homePageController.selectedCategory.value =
                                category;
                            homePageController.filterItemsByCategory();
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
    );
  }

  Widget _buildItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Free Items",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        homePageController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homePageController.filteredItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, index) => _buildItemCard(
                    homePageController.filteredItems[index], index),
              ),
      ],
    );
  }

  Widget _buildItemCard(ItemModel item, int index) {
    final mediaList = item.media ?? [];
    final imageUrl = mediaList.isNotEmpty ? mediaList[0].originalUrl : null;
    final price = item.isFree == '1' ? 'Free' : '\$${item.price}';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE1E1E1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl ??
                      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                  height: 75,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(.4),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          homePageController.toggleFavorite(index);
                        },
                        child: Obx(() {
                          return Icon(
                            homePageController.favoritedItemIds
                                    .contains(item.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.description ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                onPressed: () =>
                    Get.toNamed(Routes.VIEWDETAIL, arguments: item),
                child: const Text("View Details",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSortPressed() async {
    final result = await Get.toNamed(Routes.SORTVIEW);
    if (result != null) {
      final selectedMiles = result['miles'];

      homePageController.applySortFilters(
        toDate: result['to'],
        fromDate: result['from'],
        miles: selectedMiles == null
            ? null
            : int.tryParse(selectedMiles?.replaceAll(RegExp(r'[^0-9]'), '')) ??
                0,
      );
    }
  }

  void _onFilterPressed() async {
    final result = await Get.to(() => const FilterView());
    if (result != null && result is Map) {
      await homePageController.filterItemsByAllConditions();
      setState(() {});
    }
  }
}
