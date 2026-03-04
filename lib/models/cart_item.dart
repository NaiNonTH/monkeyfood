import 'package:monkeyfood/models/food_entry.dart';

class CartItem {
  final FoodEntry item;
  int amount;

  CartItem(this.item, {this.amount = 1});

  CartItem copyWith({FoodEntry? item, int? amount}) {
    return CartItem(item ?? this.item, amount: amount ?? this.amount);
  }
}
