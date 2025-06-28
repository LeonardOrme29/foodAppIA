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
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen con tamaño fijo
            SizedBox(
              height: 100,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Texto con padding y truncamiento si es largo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
