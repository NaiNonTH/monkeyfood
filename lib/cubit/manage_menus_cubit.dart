import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/manage_menus_state.dart';

class ManageMenusCubit extends Cubit<ManageMenusState> {
  final FoodRepositories _foodRepositories;

  ManageMenusCubit(this._foodRepositories) : super(ManageMenusInit());

  Future<void> loadMenus(int restaurantId) async {
    emit(LoadingMenus());

    try {
      final foods = await _foodRepositories.getMenus(restaurantId);

      emit(MenusLoaded(foods: foods));
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> searchMenus(int restaurantId, String query) async {
    emit(LoadingMenus());

    try {
      final results = await _foodRepositories.searchMenus(restaurantId, query);

      emit(MenusLoaded(foods: results));
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> resetResults() async {
    emit(ManageMenusInit());
  }

  Future<void> addFood(int restaurantId, FoodUpload food) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.addFood(restaurantId, food);

      emit(MenusModified());
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> updateFoodDetails(int foodId, FoodEdit food) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.updateFoodDetails(foodId, food);

      emit(MenusModified());
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> updateFoodImage(String path, Uint8List bytes) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.updateFoodImage(path, bytes);

      emit(MenusModified());
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> deleteFood(int foodId) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.deleteFood(foodId);

      emit(MenusModified());
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> reset() async {
    emit(ManageMenusInit());
  }
}
