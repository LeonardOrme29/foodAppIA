import 'dart:convert';
class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'password': password,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
    firstname: json['firstname'] ?? '',
    lastname: json['lastname'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
  );
}