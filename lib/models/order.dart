import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/models/profile.dart';

enum OrderStatus { preparing, delivering, delivered }

class Order {
  final int id;
  final List<OrderItem> items;
  final Profile profile;
  final double totalPrice;

  Order({
    required this.id,
    required this.items,
    required this.profile,
    required this.totalPrice,
  });
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
