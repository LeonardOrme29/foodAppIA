import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;

  const FoodCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(item.imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(item.title),
          ),
        ],
      ),
    );
  }
}
