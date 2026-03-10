import 'package:monkeyfood/models/food.dart';

abstract class FoodsState {}

class FoodsInit extends FoodsState {}

class FoodsLoading extends FoodsState {}

class FoodsLoaded extends FoodsState {
  final List<Food> foods;

  FoodsLoaded({required this.foods});
}

class FoodsError extends FoodsState {
  final String message;

  FoodsError({required this.message});
}
