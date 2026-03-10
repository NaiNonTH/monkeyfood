import 'dart:math';

import 'package:monkeyfood/models/food_entry.dart';

class CartItem {
  final FoodEntry item;
  int amount;
  int totalPrice;
  int totalOriginalPrice;

  CartItem(this.item, {this.amount = 1})
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

  CartItem copyWith({FoodEntry? item, int? amount}) {
    return CartItem(item ?? this.item, amount: amount ?? this.amount);
  }
}
