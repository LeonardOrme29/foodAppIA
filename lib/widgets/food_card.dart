import 'package:flutter/material.dart';
import 'package:food_app/views/dish_details_view.dart';
import '../models/food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;
  const FoodCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailsView(item: item),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.network(item.imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(item.name),
            ),
          ],
        ),
      ),
    );
  }
}
