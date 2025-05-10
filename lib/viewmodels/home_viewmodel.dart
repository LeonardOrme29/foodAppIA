import 'package:flutter/material.dart';
import '../models/food_item.dart';

class HomeViewModel extends ChangeNotifier {
  List<FoodItem> featuredSearches = [];
  List<FoodItem> mySearches = [];

  HomeViewModel() {
    _loadData();
  }

  void _loadData() {
    final item = FoodItem(
      title: 'Lomo Saltado',
      imageUrl: 'lib/assets/lomo-saltado.jpg', // cambia por tu imagen
    );
    featuredSearches = List.generate(5, (_) => item);
    mySearches = List.generate(6, (_) => item);
    notifyListeners();
  }
}
