import 'package:monkeyfood/models/food.dart';

abstract class FoodState {}

class FoodInit extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final FoodDisplay food;

  FoodLoaded({required this.food});
}

class FoodError extends FoodState {
  final String message;

  FoodError({required this.message});
}
