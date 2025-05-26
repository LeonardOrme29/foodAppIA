import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_app/models/app_Enviroment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ingredients.dart';

class DishDetailViewModel {
  Future<List<Ingredients>> loadIngredients(dynamic idItem) async {
    final url = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/$idItem");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      final ingredients = data.map((ingredient) => Ingredients.fromJson(ingredient)).toList();
      return ingredients;
    } else {
      throw Exception('Failed to load ingredients');
    }
  }
}
