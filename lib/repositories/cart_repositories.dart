import 'package:monkeyfood/models/cart_item.dart';

class CartRepositories {
  static final List<CartItem> _cartItems = [];

  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(Duration(seconds: 1));

    return _cartItems;
  }

  Future<void> addToCart(CartItem item) async {
    await Future.delayed(Duration(seconds: 1));

    final matchedItemIndex = _cartItems.indexWhere(
      (cartItem) => cartItem.item.id == item.item.id,
    );

    if (matchedItemIndex >= 0) {
      _cartItems[matchedItemIndex].amount += 1;
    } else {
      _cartItems.add(item);
    }
  }

  Future<int> incrementItemAmount(int index) async {
    await Future.delayed(Duration(seconds: 1));

    return _cartItems[index].incrementAmount();
  }

  Future<int> decrementItemAmount(int index) async {
    await Future.delayed(Duration(seconds: 1));

    return _cartItems[index].decrementAmount();
  }

  Future<void> removeFromCart(int id) async {
    await Future.delayed(Duration(seconds: 1));

    _cartItems.removeAt(id);
  }
}
