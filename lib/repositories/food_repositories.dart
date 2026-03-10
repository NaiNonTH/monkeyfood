import 'dart:math';

import 'package:monkeyfood/models/food.dart';

class FoodRepositories {
  static final _dummyFoodEntires = List.generate(
    10,
    (index) => Food(
      id: index,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
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
