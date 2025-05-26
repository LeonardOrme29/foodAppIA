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
}
