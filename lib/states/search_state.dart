import 'package:monkeyfood/models/food.dart';

abstract class SearchState {}

class SearchInit extends SearchState {}

class Searching extends SearchState {
  final List<FoodWithAvgRating>? oldResults;

  Searching({this.oldResults});
}

class Searched extends SearchState {
  final List<FoodWithAvgRating> results;

  Searched({required this.results});
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
