import 'dart:math';

import 'package:monkeyfood/models/food.dart';

class CartItem {
  final Food item;
  int id;
  int amount;
  double totalPrice;
  double totalOriginalPrice;

  CartItem(this.item, {this.amount = 1, required this.id})
    : totalPrice = item.price * amount,
      totalOriginalPrice = item.originalPrice * amount;

  int incrementAmount() {
    amount += 1;
    totalPrice = amount * item.price;
    totalOriginalPrice = amount * item.originalPrice;
    return amount;
  }

  int decrementAmount() {
    amount = max(1, amount - 1);
    totalPrice = amount * item.price;
    totalOriginalPrice = amount * item.originalPrice;
    return amount;
  }

  CartItem copyWith({int? id, Food? item, int? amount}) {
    return CartItem(
      id: id ?? this.id,
      item ?? this.item,
      amount: amount ?? this.amount,
    );
  }
}
