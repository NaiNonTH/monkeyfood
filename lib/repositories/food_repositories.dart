import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class FoodRepositories {
  Future<List<FoodWithAvgRating>> getFoodEntries() async {
    final res = await supabase
        .from('foods_with_avg_rating')
        .select()
        .order('id', ascending: true);

    return res
        .map(
          (value) => FoodWithAvgRating(
            id: value['id'],
            title: value['title'],
            description: value['description'],
            price: value['price'].toDouble(),
            originalPrice: value['original_price'].toDouble(),
            imageName: value['image_name'],
            rating: value['avg_rating'].toDouble(),
          ),
        )
        .toList();
  }

  Future<FoodWithAvgRating> getFoodById(int id) async {
    final res = await supabase
        .from('foods_with_avg_rating')
        .select()
        .eq('id', id)
        .single();

    return FoodWithAvgRating(
      id: res['id'],
      title: res['title'],
      description: res['description'],
      price: res['price'].toDouble(),
      originalPrice: res['original_price'].toDouble(),
      imageName: res['image_name'],
      rating: res['avg_rating'].toDouble(),
    );
  }
}
