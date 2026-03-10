import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final FoodRepositories foodRepositories;

  FoodsCubit(this.foodRepositories) : super(FoodsInit());

  Future<void> loadFoodEntries() async {
    emit(FoodsLoading());

    final foods = await foodRepositories.getFoodEntries();

    emit(FoodsLoaded(foods: foods));
  }
}
