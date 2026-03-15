import 'package:monkeyfood/models/cart_item.dart';

abstract class CartState {}

class CartInit extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final bool isRefreshing;

  CartLoaded({required this.cartItems, this.isRefreshing = false});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
