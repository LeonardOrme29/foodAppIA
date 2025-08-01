import 'package:flutter/material.dart';
import 'package:food_app/models/app_Enviroment.dart';
import '../models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginViewModel extends ChangeNotifier {
  UserModel? _user;
  int _id = 1;
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  Future<bool> loginUser() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${AppEnvironment.apiBaseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email, 'password': _password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = UserModel(
          id:data['id'] ?? 1,
          firstname: data['firstname'] ?? '',
          lastname: data['lastname'] ?? '',
          email: data['email'],
          password: data['password'] ?? '', // No recomendado guardar la contraseña, es solo prueba
        );
        await saveUser(_user!); // Guardar en shared_preferences
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Credenciales incorrectas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> loadUserFromPreferences() async {
    _user = await loadUser();
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await clearUser();
    notifyListeners();
  }

  void loginWithGoogle() async {
    _user = UserModel(
      id:1,
      firstname: 'Usuario Google',
      lastname: 'Google',
      email: 'google@example.com',
      password: 'password',
    );
    await saveUser(_user!);
    notifyListeners();
  }

  void loginWithFacebook() async {
    _user = UserModel(
      id:1,
      firstname: 'Usuario Facebook',
      lastname: 'Facebook',
      email: 'facebook@example.com',
      password: 'password',
    );
    await saveUser(_user!);
    notifyListeners();
  }

  void loginWithEmail() async {
    _user = UserModel(
      id:1,
      firstname: 'Usuario Email',
      lastname: 'Mail',
      email: 'email@example.com',
      password: 'password',
    );
    await saveUser(_user!);
    notifyListeners();
  }
}
