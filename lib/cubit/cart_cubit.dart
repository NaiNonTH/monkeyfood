import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepositories cartRepositories;

  CartCubit(this.cartRepositories) : super(CartInit());

  Future<void> loadCartItems() async {
    emit(CartLoading());

    final cartItems = await cartRepositories.getCartItems();

    emit(CartLoaded(cartItems: cartItems));
  }

  Future<void> addCartItem(int foodId) async {
    emit(CartLoading());

    try {
      await cartRepositories.addToCart(foodId);
    } on PostgrestException catch (e) {
      if (e.details == 'Conflict') {
        emit(CartError(message: 'This item is already in your cart.'));
      }
    }

    emit(CartItemAdded());
  }

  Future<void> incrementItemAmount(int cartId) async {
    emit(CartUpdatingAmount());

    await cartRepositories.incrementItemAmount(cartId);

    emit(CartItemUpdated());
  }

  Future<void> decrementItemAmount(int id) async {
    emit(CartUpdatingAmount());

    await cartRepositories.decrementItemAmount(id);

    emit(CartItemUpdated());
  }

  Future<void> removeCartItem(int id) async {
    emit(CartLoading());

    await cartRepositories.removeFromCart(id);

    emit(CartItemDeleted(id: id));
  }
}
