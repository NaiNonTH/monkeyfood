import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';

class FoodEntryCubit extends Cubit<FoodEntryState> {
  final FoodRepositories foodRepositories;

  FoodEntryCubit(this.foodRepositories)
    : super(FoodEntryState(foodEntries: foodRepositories.getFoodEntries()));

  void loadFoodEntries() {
    emit(state.copyWith(foodEntries: foodRepositories.getFoodEntries()));
  }
}
