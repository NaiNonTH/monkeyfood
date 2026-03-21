import 'package:monkeyfood/models/restaurant.dart';

abstract class RestaurantInfoState {}

class RestaurantInfoInit extends RestaurantInfoState {}

class LoadingRestaurantInfo extends RestaurantInfoState {}

class RestaurantInfoLoaded extends RestaurantInfoState {
  final Restaurant restaurant;

  RestaurantInfoLoaded({required this.restaurant});
}

class RestaurantInfoError extends RestaurantInfoState {
  final String message;

  RestaurantInfoError({required this.message});
}
