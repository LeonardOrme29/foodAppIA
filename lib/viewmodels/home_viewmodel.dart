import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_app/models/app_Enviroment.dart';
import '../models/food_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiUrl = String.fromEnvironment('API_URL');
const appName = String.fromEnvironment('APP_NAME');


class HomeViewModel extends ChangeNotifier {
  List<FoodItem> featuredSearches = [];
  List<FoodItem> mySearches = [];
  List<FoodItem> dishes = [];

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    final url = Uri.parse('${AppEnvironment.apiBaseUrl}/dishes/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      final items = data.map((item) => FoodItem.fromJson(item)).toList();

      // Actualizar los valores nutricionales para cada FoodItem
      for (final item in items) {
        try {
          await item.updateNutritionalInfoById(item.id);
        } catch (e) {
          print('Error al actualizar info nutricional de ${item.id}: $e');
        }
      }

      dishes = items.toList();
      featuredSearches = items.take(5).toList();

      if (items.length > 12) {
        mySearches = items.sublist(items.length - 12).reversed.toList();
      } else {
        mySearches = items.reversed.toList(); // Si hay menos de 12
      }

      notifyListeners();
    } else {
      throw Exception('Failed to load dishes');
    }
  }


}
