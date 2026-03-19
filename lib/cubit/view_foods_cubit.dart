import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/view_foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final FoodRepositories _foodRepositories;

  FoodsCubit(this._foodRepositories) : super(FoodsInit());

  Future<void> loadFoodEntries() async {
    emit(FoodsLoading());

    try {
      final foods = await _foodRepositories.getFoodEntries();

      emit(FoodsLoaded(foods: foods));
    } catch (e) {
      emit(FoodsError(message: e.toString()));
    }
  }

  Future<void> searchFoodEntries(String query) async {
    emit(FoodsLoading());

    try {
      final results = await _foodRepositories.searchFoodEntries(query);

      emit(FoodsLoaded(foods: results));
    } catch (e) {
      emit(FoodsError(message: e.toString()));
    }
  }

  Future<void> resetResults() async {
    emit(FoodsInit());
  }
}
