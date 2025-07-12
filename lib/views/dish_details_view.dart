import 'package:flutter/material.dart';
import 'package:food_app/viewmodels/dish_detail_viewmodel.dart';
import 'package:food_app/widgets/metrics_display.dart';
import '../models/food_item.dart';
import '../models/ingredients.dart';

class DishDetailsView extends StatelessWidget {
  final FoodItem item;
  const DishDetailsView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: item.updateNutritionalInfoById(item.id), // Aquí se actualiza
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        return _buildScaffold(context); // Muestra la vista completa una vez cargado
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageDisplayWidth = screenWidth.clamp(0.0, 600.0);
    final imageDisplayHeight = imageDisplayWidth * (400 / 600);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
                  (route) => false,
              arguments: {'reload': true}, // Puedes usar esto para indicarle al Home que recargue
            );
          },
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/icono.png', height: 40),
            const SizedBox(width: 5),
            const Text("FoodScan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D3D),
      ),
      body: Column(
        children: [
          item.imageUrl.isNotEmpty
              ? Container(
            width: double.infinity,
            height: imageDisplayHeight,
            alignment: Alignment.center,
            child: Image.network(
              item.imageUrl,
              width: imageDisplayWidth,
              height: imageDisplayHeight,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey[600]),
                  ),
                );
              },
            ),
          )
              : Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: Text('No hay imagen disponible',
                  style: TextStyle(color: Colors.grey[600])),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MetricsDisplay(
              precision: item.accuracy,
              carbs: item.carbohidratos ?? 0.0,
              proteins: item.proteina ?? 0.0,
              fats: item.grasas ?? 0.0,
            ),
          ),
          const SizedBox(height: 16),
          Text('Category: ${item.category}', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Ingredients:', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Ingredients>>(
              future: item.getIngredients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No ingredients found.'));
                } else {
                  final ingredients = snapshot.data!;
                  return ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      return ListTile(
                        leading: const Icon(Icons.kitchen),
                        title: Text(ingredient.name),
                        subtitle: Text('Category: ${ingredient.category}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
