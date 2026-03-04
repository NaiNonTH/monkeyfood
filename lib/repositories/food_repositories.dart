import 'dart:math';

import 'package:monkeyfood/models/food_entry.dart';

class FoodRepositories {
  static final _dummyFoodEntires = List.generate(
    10,
    (index) => FoodEntry(
      id: index,
      title: 'Food Item $index',
      price: (index + 1) * 5,
      originalPrice: (index + 1) * 7,
      rating: min(Random().nextDouble() * 5 + 3, 5),
      imageUrl: 'https://picsum.photos/300/400?random=$index',
    ),
  );

  List<FoodEntry> getFoodEntries() {
    return _dummyFoodEntires;
  }

  FoodEntry getFoodEntryById(int id) {
    return _dummyFoodEntires[id];
  }
}
