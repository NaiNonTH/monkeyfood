import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/order_repositories.dart';
import 'package:monkeyfood/states/change_order_status_state.dart';

class ChangeOrderStatusCubit extends Cubit<ChangeOrderStatusState> {
  final OrderRepositories _orderRepositories;

  ChangeOrderStatusCubit(this._orderRepositories)
    : super(ChangeOrderStatusInit());

  Future<void> toDelivery(int orderItemId) async {
    emit(ChangingOrderStatus(orderItemId: orderItemId));

    try {
      await _orderRepositories.toDelivery(orderItemId);

      emit(OrderStatusChanged());
    } catch (e) {
      emit(ChangeOrderStatusError(message: e.toString()));
    }
  }

  Future<void> finishDelivery(int orderItemId) async {
    emit(ChangingOrderStatus(orderItemId: orderItemId));

    try {
      await _orderRepositories.finishDelivery(orderItemId);

      emit(OrderStatusChanged());
    } catch (e) {
      emit(ChangeOrderStatusError(message: e.toString()));
    }
  }
}
