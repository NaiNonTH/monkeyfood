abstract class ChangeOrderStatusState {}

class ChangeOrderStatusInit extends ChangeOrderStatusState {}

class ChangingOrderStatus extends ChangeOrderStatusState {
  final int orderItemId;

  ChangingOrderStatus({required this.orderItemId});
}

class OrderStatusChanged extends ChangeOrderStatusState {}

class ChangeOrderStatusError extends ChangeOrderStatusState {
  final String message;

  ChangeOrderStatusError({required this.message});
}
