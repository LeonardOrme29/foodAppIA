import 'dart:convert';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/app_Enviroment.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../services/user_preferences.dart';

class HistoryViewModel {
  List<FoodItem> history = [];

  Future<void> loadHistory() async {
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

        history = items.reversed.toList();
      } else {
        print('❌ Error al cargar historial: ${response.statusCode}');
      }
    } catch (e) {
      print('🧨 Excepción en loadHistory: $e');
    }
  }
}
