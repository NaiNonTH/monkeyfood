import 'dart:ui';

import 'package:monkeyfood/models/cart_item.dart';

class CartRepositories {
  static final List<CartItem> _cartItems = [];

  List<CartItem> getCartItems() {
    return _cartItems;
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
  }

  void updateCartItemAmount(int index, int amount) {
    _cartItems[index].amount = clampDouble(amount.toDouble(), 1, 5).toInt();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
  }
}
