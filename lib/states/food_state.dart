import 'package:monkeyfood/models/food.dart';

abstract class FoodState {}

class FoodInit extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final FoodWithAvgRating food;

  FoodLoaded({required this.food});
}

class FoodError extends FoodState {
  final String message;

  FoodError({required this.message});
}
