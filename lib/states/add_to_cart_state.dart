abstract class AddToCartState {}

class AddToCartInit extends AddToCartState {}

class AddingToCart extends AddToCartState {}

class AddedToCart extends AddToCartState {}

class AddToCartError extends AddToCartState {
  final String message;

  AddToCartError({required this.message});
}
