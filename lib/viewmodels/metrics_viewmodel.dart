import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../services/user_preferences.dart';
import 'package:food_app/models/app_Enviroment.dart';

class MetricsViewModel {
  double grasas = 0.0;
  double carbohidratos = 0.0;
  double proteinas = 0.0;
  String? error;

  Future<void> fetchAverages() async {
    try {
      final UserModel? user = await loadUser();

      if (user == null) {
        error = '⚠️ Usuario no encontrado';
        return;
      }

      final url = Uri.parse("${AppEnvironment.apiBaseUrl}/dishes/average");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"user_id": user.id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        grasas = (data['average_grasas'] as num?)?.toDouble() ?? 0.0;
        carbohidratos = (data['average_carbohidratos'] as num?)?.toDouble() ?? 0.0;
        proteinas = (data['average_proteinas'] as num?)?.toDouble() ?? 0.0;
        error = null;
      } else {
        error = '❌ Error al consultar: ${response.statusCode}';
      }
    } catch (e) {
      error = '🧨 Excepción: $e';
    }
  }

  Map<String, double> get dataMap => {
    "Grasas": grasas,
    "Carbohidratos": carbohidratos,
    "Proteínas": proteinas,
  };
}
