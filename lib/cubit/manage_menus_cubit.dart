import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/manage_menus_state.dart';

class ManageMenusCubit extends Cubit<ManageMenusState> {
  final FoodRepositories _foodRepositories;

  ManageMenusCubit(this._foodRepositories) : super(ManageMenusInit());

  Future<void> loadFoodEntries() async {
    emit(LoadingMenus());

    try {
      final foods = await _foodRepositories.getFoodEntries();

      emit(MenusLoaded(foods: foods));
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> searchFoodEntries(String query) async {
    emit(LoadingMenus());

    try {
      final results = await _foodRepositories.searchFoodEntries(query);

      emit(MenusLoaded(foods: results));
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> resetResults() async {
    emit(ManageMenusInit());
  }

  Future<void> addFood(FoodUpload food) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.addFood(food);

      emit(MenusModified());
    } catch (e) {
      emit(ManageMenusError(message: e.toString()));
    }
  }

  Future<void> updateFood(int foodId, FoodEdit food) async {
    emit(ModifyingMenus());

    try {
      await _foodRepositories.updateFood(foodId, food);

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
