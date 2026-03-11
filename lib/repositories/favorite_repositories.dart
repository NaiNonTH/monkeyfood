import 'dart:core';

import 'package:monkeyfood/models/food.dart';

class FavoriteRepositories {
  static final List<Food> _favoriteItems = [];

  List<Food> getFavoriteItems() {
    return _favoriteItems;
  }

  bool includes(Food food) {
    return _favoriteItems.contains(food);
  }

  void addToFavorite(Food food) {
    _favoriteItems.add(food);
  }

  void removeFromFavorite(Food food) {
    _favoriteItems.remove(food);
  }
}
