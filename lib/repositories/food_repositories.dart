import 'dart:math';

import 'package:monkeyfood/models/food.dart';

class FoodRepositories {
  static final _dummyFoodEntires = List.generate(
    10,
    (index) => Food(
      id: index,
      title: 'Food Item $index',
      price: (index + 1) * 5,
      originalPrice: (index + 1) * 7,
      rating: min(Random().nextDouble() * 5 + 3, 5),
      imageUrl: 'https://picsum.photos/300/400?random=$index',
    ),
  );

  Future<List<Food>> getFoodEntries() async {
    await Future.delayed(Duration(seconds: 1));

    return _dummyFoodEntires;
  }

  Future<Food> getFoodById(int id) async {
    await Future.delayed(Duration(seconds: 1));

    return _dummyFoodEntires[id];
  }
}
