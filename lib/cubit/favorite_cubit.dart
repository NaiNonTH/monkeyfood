import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food.dart';
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

  void addFavoriteItem(Food food) {
    favoriteRepositories.addToFavorite(food);
    emit(state.copyWith(favoriteRepositories.getFavoriteItems()));
  }

  void removeFavoriteItem(Food food) {
    favoriteRepositories.removeFromFavorite(food);
    emit(state.copyWith(favoriteRepositories.getFavoriteItems()));
  }
}
