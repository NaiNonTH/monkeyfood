import 'dart:core';

import 'package:monkeyfood/models/food.dart';

class FavoriteRepositories {
  static final List<Food> _favoriteItems = [];

  List<Food> getFavoriteItems() {
    return _favoriteItems;
  }

  bool includes(Food Food) {
    return _favoriteItems.contains(Food);
  }

  void addToFavorite(Food Food) {
    _favoriteItems.add(Food);
  }

  void removeFromFavorite(Food Food) {
    _favoriteItems.remove(Food);
  }
}
