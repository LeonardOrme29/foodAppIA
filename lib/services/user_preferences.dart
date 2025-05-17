import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

Future<void> saveUser(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());
  await prefs.setString('user', userJson);
}

Future<UserModel?> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');
  if (userJson == null) return null;

  Map<String, dynamic> userMap = jsonDecode(userJson);
  return UserModel.fromJson(userMap);
}

Future<void> clearUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
}
