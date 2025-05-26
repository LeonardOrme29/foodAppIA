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
      dishes=items.toList();
      featuredSearches = items.take(5).toList();
      mySearches = items.take(6).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load dishes');
    }
  }

}
