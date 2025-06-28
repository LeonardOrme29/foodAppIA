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
  final int user;
  final String accuracy;
  double? proteina; // Changed from String? to double?
  double? carbohidratos; // Changed from String? to double?
  double? grasas; // Changed from String? to double?

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.user,
    required this.accuracy,
    this.proteina,
    this.carbohidratos,
    this.grasas,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['dishmodel_id'] as int,
      name: json['category'] as String,
      imageUrl: json['url_image'] ?? 'lib/assets/default.png',
      category: json['category'] as String,
      user: json['user_id'] as int,
      accuracy: json['accuracy'] as String,
      // Cast to double? for nutritional fields
      proteina: json['proteina'] as double?,
      carbohidratos: json['carbohidratos'] as double?,
      grasas: json['grasas'] as double?,
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
    required String category,
    required String imageUrl,
    required String accuracy,
    required int userId
  }) async {
    final uploadUrl = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/upload");

    final Map<String, dynamic> payload = {
      "category": category,
      "url_image": imageUrl,
      "accuracy": accuracy,
      "user_id": userId
    };

    // Agregado para debug:
    print("Categoría enviada: $category");
    print("Payload completo a enviar: $payload");

    try {
      final uploadResponse = await http.post(
        uploadUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (uploadResponse.statusCode == 201 || uploadResponse.statusCode == 200) {
        final uploadData = json.decode(uploadResponse.body);

        print('Upload Response Data: $uploadData'); // Para depuración

        final int? newFoodItemId = uploadData['dishmodel_id'] as int?;

        if (newFoodItemId == null) {
          throw Exception("API no devolvió 'dishmodel_id' en la respuesta. Respuesta: $uploadData");
        }

        final FoodItem initialFoodItem = FoodItem(
          id: newFoodItemId,
          name: uploadData['category'] as String,
          imageUrl: uploadData['url_image'] ?? 'lib/assets/default.png',
          category: uploadData['category'] as String,
          user: uploadData['user_id'] as int,
          accuracy: uploadData['accuracy'] as String,
          proteina: null,
          carbohidratos: null,
          grasas: null,
        );

        final detailsUrl = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/$newFoodItemId");
        final detailsResponse = await http.get(detailsUrl);

        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);

          return FoodItem(
            id: initialFoodItem.id,
            name: initialFoodItem.category,
            imageUrl: initialFoodItem.imageUrl,
            category: initialFoodItem.category,
            user: initialFoodItem.user,
            accuracy: initialFoodItem.accuracy,
            proteina: detailsData['proteina'] as double?,
            carbohidratos: detailsData['carbohidratos'] as double?,
            grasas: detailsData['grasas'] as double?,
          );
        } else {
          throw Exception("Error al obtener detalles nutricionales (ID: ${initialFoodItem.id}): ${detailsResponse.statusCode} - ${detailsResponse.body}");
        }
      } else {
        throw Exception("Error al crear alimento: ${uploadResponse.statusCode} - ${uploadResponse.body}");
      }
    } catch (e) {
      throw Exception("Excepción en createFoodItem: ${e.toString()}");
    }
  }

  Future<void> updateNutritionalInfoById(int idModel) async {
    final url = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/$idModel");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Actualiza los valores nutricionales
        proteina = data['proteinas'] as double?;
        carbohidratos = data['carbohidratos'] as double?;
        grasas = data['grasas'] as double?;
      } else {
        throw Exception("Error al obtener información nutricional: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Excepción al actualizar valores nutricionales: ${e.toString()}");
    }
  }

}
