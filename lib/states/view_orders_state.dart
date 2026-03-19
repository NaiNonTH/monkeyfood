import 'package:monkeyfood/models/order.dart';

abstract class OrderState {}

class OrderInit extends OrderState {}

class LoadingOrder extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  OrderLoaded({required this.orders});
}

class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});
}
