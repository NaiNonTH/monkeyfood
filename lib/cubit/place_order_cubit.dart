import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/repositories/order_repositories.dart';
import 'package:monkeyfood/states/place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  final OrderRepositories orderRepositories;

  PlaceOrderCubit(this.orderRepositories) : super(PlaceOrderInit());

  Future<void> placeOrder(List<CartItem> cartItems) async {
    emit(PlacingOrder());

    try {
      orderRepositories.placeOrder(cartItems);

      emit(OrderPlaced());
    } catch (e) {
      emit(PlaceOrderError(message: e.toString()));
    }
  }
}
