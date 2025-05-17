import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void setFirstName(String value) {
    firstname = value;
    notifyListeners();
  }

  void setLastName(String value) {
    lastname = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<bool> registerUser() async {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save(); // Guarda valores del formulario
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // CAMBIA ESTA LÍNEA según tu entorno:
    // Emulador Android: 10.0.2.2
    // Dispositivo físico / iOS: usa tu IP local (ej. 192.168.0.101)
    final url = Uri.parse('http://127.0.0.1:8000/register/');

    final Map<String, String> body = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Registro exitoso: ${response.body}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('❌ Error en el registro: ${response.statusCode}');
        print('🧾 Respuesta: ${response.body}');
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['detail'] ?? 'Error desconocido durante el registro.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      print('🚫 Error de conexión: $error');
      _errorMessage = 'No se pudo conectar al servidor.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
