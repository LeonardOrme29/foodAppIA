import 'package:flutter/cupertino.dart';

class Ingredients{
  final String name;
  final String category;

  Ingredients({
    required this.name,
    required this.category,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
      name: json['name'],
      category: json['category'],
    );
  }
}