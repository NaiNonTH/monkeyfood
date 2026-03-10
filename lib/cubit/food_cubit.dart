import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepositories foodRepositories;

  FoodCubit(this.foodRepositories) : super(FoodInit());

  Future<void> loadFoodById(int id) async {
    emit(FoodLoading());

    final food = await foodRepositories.getFoodById(id);

    emit(FoodLoaded(food: food));
  }
}
