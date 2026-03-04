import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepositories cartRepositories;

  CartCubit(this.cartRepositories)
    : super(CartState(cartItems: cartRepositories.getCartItems()));

  void loadCartItems() {
    emit(state.copyWith(cartItems: cartRepositories.getCartItems()));
  }

  void addCartItem(CartItem item) {
    cartRepositories.addToCart(item);
    emit(state.copyWith(cartItems: cartRepositories.getCartItems()));
  }

  void updateCartItemAmount(int index, int amount) {
    cartRepositories.updateCartItemAmount(index, amount);
    emit(state.copyWith(cartItems: cartRepositories.getCartItems()));
  }

  void removeCartItem(CartItem item) {
    cartRepositories.removeFromCart(item);
    emit(state.copyWith(cartItems: cartRepositories.getCartItems()));
  }
}
