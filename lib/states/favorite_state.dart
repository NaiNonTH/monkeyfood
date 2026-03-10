import 'package:monkeyfood/models/food.dart';

class FavoriteState {
  final List<Food> favoriteItems;

  FavoriteState({required this.favoriteItems});

  FavoriteState copyWith(List<Food>? favoriteItems) {
    return FavoriteState(favoriteItems: favoriteItems ?? this.favoriteItems);
  }
}
