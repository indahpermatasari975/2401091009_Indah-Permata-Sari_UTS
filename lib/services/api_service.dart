import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  ApiService._();

  static Future<Map<String, dynamic>> _fetchJson(String path) async {
    final uri = Uri.parse('$_baseUrl/$path');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw Exception('Status code ${response.statusCode} saat memanggil $path');
      }

      final body = response.body;
      if (body.isEmpty) {
        throw Exception('Response kosong dari $path');
      }

      final jsonData = jsonDecode(body);
      if (jsonData is! Map<String, dynamic>) {
        throw Exception('Format response tidak valid untuk $path');
      }

      return jsonData;
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke jaringan. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Kesalahan HTTP saat memanggil layanan.');
    } on FormatException {
      throw Exception('Response tidak dalam format JSON yang valid.');
    }
  }

  static Future<List<Category>> fetchCategories() async {
    final data = await _fetchJson('categories.php');
    final rawCategories = data['categories'];
    if (rawCategories is! List) {
      throw Exception('Data kategori tidak ditemukan atau tidak valid.');
    }

    return rawCategories
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final data = await _fetchJson('filter.php?c=${Uri.encodeQueryComponent(category)}');
    final rawMeals = data['meals'];
    if (rawMeals == null) {
      return [];
    }
    if (rawMeals is! List) {
      throw Exception('Data masakan kategori tidak valid.');
    }

    return rawMeals
        .map((item) => MealSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<MealSummary>> searchMeals(String keyword) async {
    final query = keyword.trim();
    if (query.isEmpty) {
      return [];
    }

    final data = await _fetchJson('search.php?s=${Uri.encodeQueryComponent(query)}');
    final rawMeals = data['meals'];
    if (rawMeals == null) {
      return [];
    }
    if (rawMeals is! List) {
      throw Exception('Data hasil pencarian tidak valid.');
    }

    return rawMeals
        .map((item) => MealSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<MealDetail> fetchMealDetail(String idMeal) async {
    final data = await _fetchJson('lookup.php?i=${Uri.encodeQueryComponent(idMeal)}');
    final rawMeals = data['meals'];
    if (rawMeals is! List || rawMeals.isEmpty) {
      throw Exception('Detail masakan tidak ditemukan.');
    }

    return MealDetail.fromJson(rawMeals.first as Map<String, dynamic>);
  }
}
