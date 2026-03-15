import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepositories _foodRepositories;

  FoodCubit(this._foodRepositories) : super(FoodInit());

  Future<void> loadFoodById(int id) async {
    emit(FoodLoading());

    try {
      final food = await _foodRepositories.getFoodById(id);

      emit(FoodLoaded(food: food));
    } catch (e) {
      emit(FoodError(message: e.toString()));
    }
  }
}
