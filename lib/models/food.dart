import 'package:monkeyfood/models/restaurant.dart';
import 'package:monkeyfood/models/review.dart';

class Food {
  final String title;
  final String description;
  final String imageName;
  final int id;
  final double originalPrice;
  final double price;

  Food({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageName,
  });
}

class FoodDisplay extends Food {
  final double rating;
  final Review? latestReview;
  final Restaurant restaurant;

  FoodDisplay({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.originalPrice,
    required super.imageName,
    required this.rating,
    required this.restaurant,
    this.latestReview,
  });
}
