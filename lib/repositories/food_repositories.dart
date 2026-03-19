import 'package:flutter/foundation.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/models/review.dart';
import 'package:monkeyfood/services/image_service.dart';
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
            latestReview: (value['latest_rating'] == null)
                ? null
                : Review(
                    displayName: value['latest_reviewer'],
                    rating: value['latest_rating'],
                    comment: value['latest_comment'],
                  ),
          ),
        )
        .toList();
  }

  Future<List<FoodWithAvgRating>> searchFoodEntries(String query) async {
    final res = await supabase
        .from('foods_with_avg_rating')
        .select()
        .ilike('title', '%$query%');

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
            latestReview: (value['latest_rating'] == null)
                ? null
                : Review(
                    displayName: value['latest_reviewer'],
                    rating: value['latest_rating'],
                    comment: value['latest_comment'],
                  ),
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
      latestReview: (res['latest_rating'] == null)
          ? null
          : Review(
              displayName: res['latest_reviewer'],
              rating: res['latest_rating'],
              comment: res['latest_comment'],
            ),
    );
  }

  Future<void> addFood(FoodUpload food) async {
    final fullPath = await FoodImageService.instance.uploadBinary(
      'uploads/${food.upload.name}',
      food.upload.bytes!,
    );

    final imageName = fullPath.substring(fullPath.indexOf('/') + 1);

    await supabase.from('foods').insert({
      'title': food.title,
      'description': food.description,
      'price': food.price,
      'original_price': food.originalPrice,
      'image_name': imageName,
    });
  }

  Future<void> updateFoodDetails(int foodId, FoodEdit food) async {
    await supabase
        .from('foods')
        .update({
          'title': food.title,
          'description': food.description,
          'price': food.price,
          'original_price': food.originalPrice,
        })
        .eq('id', foodId);
  }

  Future<void> updateFoodImage(String path, Uint8List bytes) async {
    await FoodImageService.instance.updateBinary(path, bytes);
  }

  Future<void> deleteFood(int foodId) async {
    await supabase.from('foods').delete().eq('id', foodId);
  }
}
