import 'package:monkeyfood/models/cart_item.dart';

class CartState {
  final List<CartItem> cartItems;

  CartState({required this.cartItems});

  CartState copyWith({List<CartItem>? cartItems}) {
    return CartState(cartItems: cartItems ?? this.cartItems);
  }
}
