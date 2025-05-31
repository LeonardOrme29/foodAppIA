import 'package:food_app/models/app_Enviroment.dart';
import 'package:food_app/models/ingredients.dart';
import '../models/ingredients.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodItem {
  final int id;
  final String name;
  final String imageUrl;
  final String category;

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['url_image'] ?? 'lib/assets/default.png',
      category: json['category'],
    );
  }

  Future<List<Ingredients>> getIngredients() async {
    final url = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/$id/ingredients");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((ingredient) => Ingredients.fromJson(ingredient)).toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  static Future<FoodItem> createFoodItem({
    //required String name,
    //required String category,
    required String imageUrl,
  }) async {
    final url = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/upload");

    final Map<String, dynamic> payload = {
      "name": "IA name",
      "category": "IA category",
      "url_image": imageUrl,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return FoodItem.fromJson(data);
      } else {
        throw Exception("Error al crear alimento: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Excepción en createFoodItem: $e");
    }
  }
}
