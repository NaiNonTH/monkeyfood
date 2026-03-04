import 'dart:core';

import 'package:monkeyfood/models/food_entry.dart';

class FavoriteRepositories {
  static final List<FoodEntry> _favoriteItems = [];

  List<FoodEntry> getFavoriteItems() {
    return _favoriteItems;
  }

  bool includes(FoodEntry foodEntry) {
    return _favoriteItems.contains(foodEntry);
  }

  void addToFavorite(FoodEntry foodEntry) {
    _favoriteItems.add(foodEntry);
  }

  void removeFromFavorite(FoodEntry foodEntry) {
    _favoriteItems.remove(foodEntry);
  }
}
