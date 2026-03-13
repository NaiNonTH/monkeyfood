import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';
import 'package:monkeyfood/states/add_to_cart_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final CartRepositories cartRepositories;

  AddToCartCubit(this.cartRepositories) : super(AddToCartInit());

  Future<void> addCartItem(int foodId) async {
    emit(AddingToCart());

    try {
      await cartRepositories.addToCart(foodId);

      emit(AddedToCart());
    } on PostgrestException catch (e) {
      if (e.details == 'Conflict') {
        emit(AddToCartError(message: 'This item is already in your cart.'));
      }
    }
  }
}
