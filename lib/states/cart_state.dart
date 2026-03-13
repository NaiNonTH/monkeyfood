import 'package:monkeyfood/models/cart_item.dart';

abstract class CartState {}

class CartInit extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded({required this.cartItems});
}

class CartItemAdded extends CartState {}

class CartUpdatingAmount extends CartState {}

class CartItemUpdated extends CartState {
  // final int id;
  // final int amount;

  // CartItemUpdated({required this.id, required this.amount});
}

class CartItemDeleted extends CartState {
  final int id;

  CartItemDeleted({required this.id});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
