import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/add_food_state.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  final FoodRepositories _foodRepositories;

  AddFoodCubit(this._foodRepositories) : super(AddFoodInit());

  Future<void> addFood(FoodUpload food) async {
    emit(AddingFood());

    try {
      await _foodRepositories.addFood(food);

      emit(FoodAdded());
    } catch (e) {
      emit(AddFoodError(message: e.toString()));
    }
  }

  Future<void> updateFood(int foodId, FoodEdit food) async {
    emit(AddingFood());

    try {
      await _foodRepositories.updateFood(foodId, food);

      emit(FoodAdded());
    } catch (e) {
      emit(AddFoodError(message: e.toString()));
    }
  }

  Future<void> deleteFood(int foodId) async {
    emit(AddingFood());

    try {
      await _foodRepositories.deleteFood(foodId);

      emit(FoodAdded());
    } catch (e) {
      emit(AddFoodError(message: e.toString()));
    }
  }

  Future<void> reset() async {
    emit(AddFoodInit());
  }
}
