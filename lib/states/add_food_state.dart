abstract class AddFoodState {}

class AddFoodInit extends AddFoodState {}

class AddingFood extends AddFoodState {}

class FoodAdded extends AddFoodState {}

class AddFoodError extends AddFoodState {
  final String message;

  AddFoodError({required this.message});
}
