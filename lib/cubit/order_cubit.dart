import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/order.dart';
import 'package:monkeyfood/repositories/order_repositories.dart';
import 'package:monkeyfood/states/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepositories _orderRepositories;

  OrderCubit(this._orderRepositories) : super(OrderInit());

  Future<void> getOrders() async {
    emit(LoadingOrder());

    try {
      List<Order> orders = await _orderRepositories.getOrders();

      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
