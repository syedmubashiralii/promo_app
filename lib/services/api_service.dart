import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  final box = GetStorage();

  String? get token => box.read('auth_token');
   String baseUrl = 'https://promo.koderspoint.com/api';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  final String _itemsKey = 'cached_items';
  final String _categoriesKey = 'cached_categories';
  final String _favoritesKey = 'cached_favorites';


  Future<List<dynamic>> fetchItems() async {
    final cachedData = box.read(_itemsKey);
    log(cachedData.toString()+"Items Cached Data");
    if (cachedData != null) {
      log("Enter ${DateTime.now().toString()}");
      _refreshItems();
      log("Returning ${DateTime.now().toString()}");
      return List<dynamic>.from(json.decode(cachedData));
    } else {
      return await _refreshItems();
    }
  }

  Future<List<dynamic>> _refreshItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items'), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        box.write(_itemsKey, json.encode(data));
        return data;
      }
    } catch (_) {}
    return [];
  }

  Future<List<dynamic>> fetchFavoriteList() async {
    final response = await http.get(Uri.parse('$baseUrl/favourite-item'), headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load favorite items');
    }
  }

  Future<bool> storeFavorite(int itemId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favourite-item/store'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'item_id': itemId}),
    );
    if (response.statusCode == 200) {
      _refreshFavoriteItems();
      return true;
    }
    return false;
  }


  Future<List<String>> fetchCategories() async {
    if (token == null || token!.isEmpty) throw Exception("No token found");

    final cached = box.read(_categoriesKey);
    if (cached != null) {
      _refreshCategories();
      final List<dynamic> cachedList = json.decode(cached);
      return cachedList.map<String>((e) => e.toString()).toList();
    } else {
      return await _refreshCategories();
    }
  }


  Future<List<String>> _refreshCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final names = data.map<String>((e) => e['name'].toString()).toList();
        box.write(_categoriesKey, json.encode(names));
        return names;
      }
    } catch (_) {}
    return [];
  }


   Future<List<Map<String, dynamic>>> fetchFavoriteItems() async {
    final token = box.read('auth_token');
    if (token == null) return [];

    final cached = box.read(_favoritesKey);
    if (cached != null) {
      _refreshFavoriteItems();
      return List<Map<String, dynamic>>.from(json.decode(cached));
    } else {
      return await _refreshFavoriteItems();
    }
  }

  Future<List<Map<String, dynamic>>> _refreshFavoriteItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favourite-item'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final items = data.map<Map<String, dynamic>>((fav) {
          final item = fav['items'][0];
          return {
            'favId': fav['id'],
            'title': item['title'] ?? '',
            'subtitle': item['description'] ?? '',
            'image': item['media'].isNotEmpty
                ? item['media'][0]['original_url']
                : 'assets/images/no_img.png',
          };
        }).toList();
        box.write(_favoritesKey, json.encode(items));
        return items;
      }
    } catch (_) {}
    return [];
  }

  Future<bool> deleteFavoriteItem(int favId) async {
    final token = box.read('auth_token');
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favourite-item/destroy/$favId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        _refreshFavoriteItems();
        return true;
      }
    } catch (_) {}
    return false;
  }


   void clearCache() {
    box.remove(_itemsKey);
    box.remove(_categoriesKey);
    box.remove(_favoritesKey);
  }
}