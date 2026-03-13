import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class CartRepositories {
  Future<List<CartItem>> getCartItems() async {
    final res = await supabase
        .from('cart_items')
        .select('''
          *,
          foods!inner ( * )
        ''')
        .eq('user_id', supabase.auth.currentUser!.id);

    return res.map((value) {
      final foodItem = value['foods'];

      final foodObj = Food(
        title: foodItem['title'],
        description: foodItem['description'],
        price: foodItem['price'].toDouble(),
        originalPrice: foodItem['original_price'].toDouble(),
        imageName: foodItem['image_name'],
        id: foodItem['id'],
      );

      return CartItem(foodObj, id: value['id'], amount: value['amount']);
    }).toList();
  }

  Future<void> addToCart(int foodId) async {
    await supabase.from('cart_items').insert({
      'user_id': supabase.auth.currentUser!.id,
      'food_id': foodId,
    });
  }

  Future<void> incrementItemAmount(int id) async {
    await supabase.rpc('increment_cart_items_amount', params: {'cart_id': id});
  }

  Future<void> decrementItemAmount(int id) async {
    await supabase.rpc('decrement_cart_items_amount', params: {'cart_id': id});
  }

  Future<void> removeFromCart(int id) async {
    await supabase.from('cart_items').delete().eq('id', id);
  }
}
