import 'package:monkeyfood/models/food_entry.dart';

class FavoriteState {
  final List<FoodEntry> favoriteItems;

  FavoriteState({required this.favoriteItems});

  FavoriteState copyWith(List<FoodEntry>? favoriteItems) {
    return FavoriteState(favoriteItems: favoriteItems ?? this.favoriteItems);
  }
}
