import 'package:monkeyfood/models/food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodRepositories {
  Future<List<Food>> getFoodEntries() async {
    try {
      final res = await Supabase.instance.client
          .from('foods')
          .select()
          .order('id', ascending: true);

      return res
          .map(
            (value) => Food(
              title: value['title'],
              description: value['description'],
              price: value['price'].toDouble(),
              originalPrice: value['original_price'].toDouble(),
              imageName: value['image_name'],
              id: value['id'],
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Food> getFoodById(int id) async {
    try {
      final res = await Supabase.instance.client
          .from('foods')
          .select()
          .eq('id', id)
          .single();

      return Food(
        title: res['title'],
        description: res['description'],
        price: res['price'].toDouble(),
        originalPrice: res['original_price'].toDouble(),
        imageName: res['image_name'],
        id: res['id'],
      );
    } catch (e) {
      return Food(
        title: 'No Food',
        description: 'ERROR ERROR!',
        price: 0.00,
        originalPrice: 0.00,
        id: id,
      );
    }
  }
}
