import 'dart:convert';
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

  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'), headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load items');
    }
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

    return response.statusCode == 200;
  }

  Future<List<String>> fetchCategories() async {

    print("token Fetch: $token");

    if (token == null || token!.isEmpty) throw Exception("No token found");

    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> categoryData = responseData['data'];
      return categoryData.map<String>((e) => e['name'].toString()).toList();
    } else {
      throw Exception("Failed to fetch categories");
    }
  }


  Future<List<Map<String, dynamic>>> fetchFavoriteItems() async {
    final token = box.read('auth_token');
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favourite-item'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return data.map<Map<String, dynamic>>((fav) {
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
      } else {
        throw Exception('Failed to fetch favorite items');
      }
    } catch (e) {
      print("Error fetching favorites: $e");
      rethrow;
    }
  }

  Future<bool> deleteFavoriteItem(int favId) async {
    final token = box.read('auth_token');
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favourite-item/destroy/$favId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error deleting favorite: $e");
      return false;
    }
  }}
