import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/models/review.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class RatingRepositories {
  Future<List<Review>> getReviews(int foodId) async {
    final res = await supabase
        .from('reviews')
        .select('*, profiles(display_name)')
        .eq('food_id', foodId);

    return res
        .map(
          (review) => Review(
            displayName: review['profiles']['display_name'],
            rating: review['rating'],
            comment: review['comment'],
          ),
        )
        .toList();
  }

  Future<List<Food>> getFoodsToRate() async {
    final reviewed = await supabase
        .from('reviews')
        .select('food_id')
        .eq('user_id', supabase.auth.currentUser!.id);

    final reviewedFoodIds = reviewed.map((r) => r['food_id']).toList();

    final query = supabase
        .from('order_items')
        .select('foods(*), orders(user_id)')
        .eq('status', 'delivered')
        .eq('orders.user_id', supabase.auth.currentUser!.id);

    final res = (reviewedFoodIds.isNotEmpty)
        ? await query.not('food_id', 'in', '(${reviewedFoodIds.join(',')})')
        : await query;

    return res.map((orderItem) {
      final food = orderItem['foods'];

      return Food(
        id: food['id'],
        title: food['title'],
        description: food['description'],
        price: food['price'].toDouble(),
        originalPrice: food['original_price'].toDouble(),
        imageName: food['image_name'],
      );
    }).toList();
  }

  Future<void> rate({
    required int foodId,
    required int ratingScore,
    String? comment,
  }) async {
    await supabase.from('reviews').insert({
      'user_id': supabase.auth.currentUser!.id,
      'food_id': foodId,
      'rating': ratingScore,
      'comment': comment,
    });
  }
}
