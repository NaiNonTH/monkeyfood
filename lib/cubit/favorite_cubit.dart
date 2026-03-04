import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food_entry.dart';
import 'package:monkeyfood/repositories/favorite_repositories.dart';
import 'package:monkeyfood/states/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepositories favoriteRepositories;

  FavoriteCubit(this.favoriteRepositories)
    : super(
        FavoriteState(favoriteItems: favoriteRepositories.getFavoriteItems()),
      );

  void loadFavoriteItems() {
    emit(state.copyWith(favoriteRepositories.getFavoriteItems()));
  }

  void addFavoriteItem(FoodEntry foodEntry) {
    favoriteRepositories.addToFavorite(foodEntry);
    loadFavoriteItems();
  }

  void removeFavoriteItem(FoodEntry foodEntry) {
    favoriteRepositories.removeFromFavorite(foodEntry);
    loadFavoriteItems();
  }
}
