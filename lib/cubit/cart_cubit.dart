import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/cart_state.dart';
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

  Future<void> incrementItemAmount(int cartId) async {
    emit(CartUpdatingAmount());

    try {
      await _cartRepositories.incrementItemAmount(cartId);

      emit(CartItemUpdated());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> decrementItemAmount(int id) async {
    emit(CartUpdatingAmount());

    try {
      await _cartRepositories.decrementItemAmount(id);

      emit(CartItemUpdated());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> removeCartItem(int id) async {
    emit(CartLoading());

    try {
      await _cartRepositories.removeFromCart(id);

      emit(CartItemDeleted(id: id));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
