import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepositories cartRepositories;

  CartCubit(this.cartRepositories) : super(CartInit());

  Future<void> loadCartItems() async {
    emit(CartLoading());

    final cartItems = await cartRepositories.getCartItems();

    emit(CartLoaded(cartItems: cartItems));
  }

  Future<void> addCartItem(CartItem item) async {
    emit(CartLoading());

    await cartRepositories.addToCart(item);

    emit(CartItemAdded());
  }

  Future<void> incrementItemAmount(int id) async {
    emit(CartUpdatingAmount());

    final newAmount = await cartRepositories.incrementItemAmount(id);

    emit(CartItemUpdated(id: id, amount: newAmount));
  }

  Future<void> decrementItemAmount(int id) async {
    emit(CartUpdatingAmount());

    final newAmount = await cartRepositories.decrementItemAmount(id);

    emit(CartItemUpdated(id: id, amount: newAmount));
  }

  Future<void> removeCartItem(int id) async {
    emit(CartLoading());

    await cartRepositories.removeFromCart(id);

    emit(CartItemDeleted(id: id));
  }
}
