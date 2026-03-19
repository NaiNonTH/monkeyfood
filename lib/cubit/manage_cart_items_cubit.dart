import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/manage_cart_items_state.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepositories _cartRepositories;

  CartCubit(this._cartRepositories) : super(CartInit());

  Future<void> loadCartItems() async {
    emit(CartLoading());

    try {
      final cartItems = await _cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> refreshCartItems() async {
    final current = state;

    if (current is CartLoaded) {
      emit(CartLoaded(cartItems: current.cartItems, isRefreshing: true));
    }

    try {
      final cartItems = await _cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> incrementItemAmount(int cartId) async {
    final current = state as CartLoaded;

    if (state is! CartLoaded) return;

    current.cartItems
        .where((cartItem) => cartItem.id == cartId)
        .single
        .incrementAmount();

    emit(CartLoaded(cartItems: current.cartItems, isRefreshing: true));

    try {
      await _cartRepositories.incrementItemAmount(cartId);

      final cartItems = await _cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> decrementItemAmount(int cartId) async {
    final current = state as CartLoaded;

    if (state is! CartLoaded) return;

    current.cartItems
        .where((cartItem) => cartItem.id == cartId)
        .single
        .decrementAmount();

    emit(CartLoaded(cartItems: current.cartItems, isRefreshing: true));

    try {
      await _cartRepositories.decrementItemAmount(cartId);

      final cartItems = await _cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> removeCartItem(int cartId) async {
    final current = state as CartLoaded;

    if (state is! CartLoaded) return;

    emit(CartLoaded(cartItems: current.cartItems, isRefreshing: true));

    try {
      await _cartRepositories.removeFromCart(cartId);

      final cartItems = await _cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
