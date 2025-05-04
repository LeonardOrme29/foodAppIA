import 'package:flutter/material.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void loginWithGoogle() {
    // Simular autenticación
    _user = UserModel(name: 'Usuario Google', email: 'google@example.com', password: 'password');
    notifyListeners();
  }

  void loginWithFacebook() {
    _user = UserModel(name: 'Usuario Facebook', email: 'facebook@example.com', password: 'password');
    notifyListeners();
  }

  void loginWithEmail() {
    _user = UserModel(name: 'Usuario Email', email: 'email@example.com', password: 'password');
    notifyListeners();
  }
}
