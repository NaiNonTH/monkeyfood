import 'package:monkeyfood/models/food.dart';

abstract class RatingState {}

class RatingInit extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {
  final List<Food> foods;
  final bool isRefreshing;

  RatingLoaded({required this.foods, this.isRefreshing = false});
}

class RatingError extends RatingState {
  final String message;

  RatingError({required this.message});
}
