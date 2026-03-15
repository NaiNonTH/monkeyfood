import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/repositories/favorite_repositories.dart';
import 'package:monkeyfood/states/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepositories _favoriteRepositories;

  FavoriteCubit(this._favoriteRepositories)
    : super(
        FavoriteState(favoriteItems: _favoriteRepositories.getFavoriteItems()),
      );

  void loadFavoriteItems() {
    emit(state.copyWith(_favoriteRepositories.getFavoriteItems()));
  }

  void addFavoriteItem(Food food) {
    _favoriteRepositories.addToFavorite(food);
    emit(state.copyWith(_favoriteRepositories.getFavoriteItems()));
  }

  void removeFavoriteItem(int id) {
    _favoriteRepositories.removeFromFavorite(id);
    emit(state.copyWith(_favoriteRepositories.getFavoriteItems()));
  }
}
