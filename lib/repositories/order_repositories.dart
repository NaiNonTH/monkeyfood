import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/models/order.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class OrderRepositories {
  Future<List<Order>> getOrders() async {
    final res = await supabase
        .from('orders')
        .select('''
          *,
          order_items(*, foods(*))
        ''')
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    return res.map((order) {
      final orderItems = (order['order_items'] as List)
          .map<OrderItem>(
            (orderItem) => OrderItem(
              id: orderItem['id'],
              amount: orderItem['amount'],
              food: Food(
                id: orderItem['foods']['id'],
                title: orderItem['foods']['title'],
                description: orderItem['foods']['description'],
                price: orderItem['foods']['price'].toDouble(),
                originalPrice: orderItem['foods']['original_price'].toDouble(),
                imageName: orderItem['foods']['image_name'],
              ),
              unitPrice: orderItem['unit_price'],
              status: OrderStatus.values.byName(orderItem['status']),
            ),
          )
          .toList();

      return Order(
        id: order['id'],
        items: orderItems,
        totalPrice: order['total_price'].toDouble(),
        orderDate: DateTime.parse(order['created_at']),
      );
    }).toList();
  }

  Future<void> placeOrder(List<CartItem> cartItems) async {
    double totalPrice = 0;

    for (var cartItem in cartItems) {
      totalPrice += (cartItem.item.price * cartItem.amount);
    }

    final returnedId = await supabase
        .from('orders')
        .insert({
          'user_id': supabase.auth.currentUser!.id,
          'total_price': totalPrice,
        })
        .select('id')
        .single();

    List<Map<String, dynamic>> orderItemsToInsert = [];

    for (var cartItem in cartItems) {
      orderItemsToInsert.add({
        'order_id': returnedId['id'],
        'food_id': cartItem.item.id,
        'unit_price': cartItem.item.price,
        'amount': cartItem.amount,
      });
    }

    await supabase.from('order_items').insert(orderItemsToInsert);

    await supabase
        .from('cart_items')
        .delete()
        .eq('user_id', supabase.auth.currentUser!.id);
  }
}
