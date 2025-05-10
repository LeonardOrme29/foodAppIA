import 'package:flutter/material.dart';
import '../models/user_model.dart';

class RegisterViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setName(String value) {
    name = value;
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

  Future<void> registerUser() async {
    if (!formKey.currentState!.validate()) return;
    _isLoading = true;
    notifyListeners();

    // Simulación de registro (puedes conectar a Firebase o backend real)
    await Future.delayed(Duration(seconds: 2));

    print("Usuario registrado: $name, $email");

    _isLoading = false;
    notifyListeners();
  }
}