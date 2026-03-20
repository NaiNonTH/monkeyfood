abstract class JoinRestaurantState {}

class JoinRestaurantInit extends JoinRestaurantState {}

class JoiningRestaurant extends JoinRestaurantState {}

class RestaurantJoined extends JoinRestaurantState {}

class JoinRestaurantError extends JoinRestaurantState {
  final String message;

  JoinRestaurantError({required this.message});
}
