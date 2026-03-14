import 'package:monkeyfood/models/food.dart';

enum OrderStatus { preparing, delivering, delivered }

class Order {
  final int id;
  final List<OrderItem> items;
  final double totalPrice;

  Order({required this.id, required this.items, required this.totalPrice});
}

class OrderItem {
  final int id;
  final int amount;
  final Food food;
  final double unitPrice;
  final OrderStatus status;

  OrderItem({
    required this.id,
    required this.amount,
    required this.food,
    required this.unitPrice,
    required this.status,
  });
}
