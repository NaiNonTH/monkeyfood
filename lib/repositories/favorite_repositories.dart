import 'dart:core';

import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/preference_service.dart';

class FavoriteRepositories {
  List<Food> getFavoriteItems() {
    final jsonFavItems = preferenceService.getFavoriteItems();

    return jsonFavItems
        .map(
          (jsonFavItem) => Food(
            id: jsonFavItem['id'],
            title: jsonFavItem['title'],
            description: jsonFavItem['description'],
            price: jsonFavItem['price'],
            originalPrice: jsonFavItem['original_price'],
            imageName: jsonFavItem['image_name'],
          ),
        )
        .toList();
  }

  bool includes(Food food) {
    return getFavoriteItems().contains(food);
  }

  Future<void> addToFavorite(Food food) async {
    await preferenceService.addFavoriteItem({
      'id': food.id,
      'title': food.title,
      'description': food.description,
      'price': food.price,
      'original_price': food.originalPrice,
      'image_name': food.imageName,
    });
  }

  Future<void> removeFromFavorite(int id) async {
    await preferenceService.removeFavoriteItem(id);
  }
}
