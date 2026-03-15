import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepositories cartRepositories;

  CartCubit(this.cartRepositories) : super(CartInit());

  Future<void> loadCartItems() async {
    emit(CartLoading());

    try {
      final cartItems = await cartRepositories.getCartItems();

      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> incrementItemAmount(int cartId) async {
    emit(CartUpdatingAmount());

    try {
      await cartRepositories.incrementItemAmount(cartId);

      emit(CartItemUpdated());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> decrementItemAmount(int id) async {
    emit(CartUpdatingAmount());

    try {
      await cartRepositories.decrementItemAmount(id);

      emit(CartItemUpdated());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> removeCartItem(int id) async {
    emit(CartLoading());

    try {
      await cartRepositories.removeFromCart(id);

      emit(CartItemDeleted(id: id));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
