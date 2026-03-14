abstract class PlaceOrderState {}

class PlaceOrderInit extends PlaceOrderState {}

class PlacingOrder extends PlaceOrderState {}

class OrderPlaced extends PlaceOrderState {}

class PlaceOrderError extends PlaceOrderState {
  final String message;

  PlaceOrderError({required this.message});
}
