import 'package:flutter/material.dart';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/app_Enviroment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../services/user_preferences.dart'; // ✅ Importar para usar loadUser()

class HomeViewModel extends ChangeNotifier {
  List<FoodItem> featuredSearches = [];
  List<FoodItem> mySearches = [];
  List<FoodItem> dishes = [];

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final UserModel? user = await loadUser();
      if (user == null) {
        print('⚠️ Usuario no encontrado en SharedPreferences');
        return;
      }

      final url = Uri.parse('${AppEnvironment.apiBaseUrl}/dishes?user_id=${user.id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        final items = data.map((item) => FoodItem.fromJson(item)).toList();

        for (final item in items) {
          try {
            await item.updateNutritionalInfoById(item.id);
          } catch (e) {
            print('⚠️ Error al actualizar info nutricional de ${item.id}: $e');
          }
        }

        dishes = items.toList();
        featuredSearches = items.take(5).toList();

        if (items.length > 12) {
          mySearches = items.sublist(items.length - 12).reversed.toList();
        } else {
          mySearches = items.reversed.toList();
        }

        notifyListeners();
      } else {
        throw Exception('❌ Error al cargar los platos: ${response.statusCode}');
      }
    } catch (e) {
      print('🧨 Excepción en _loadData: $e');
    }
  }

  // ✅ Agrega este método para permitir la recarga desde la vista
  Future<void> loadSearches() async {
    await _loadData(); // ya es async
  }


}


