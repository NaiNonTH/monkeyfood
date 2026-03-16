class Food {
  final String title;
  final String description;
  final String? imageName;
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

  Food copyWith({
    String? title,
    String? description,
    String? imageName,
    int? id,
    double? originalPrice,
    double? price,
    double? rating,
  }) {
    return Food(
      title: title ?? this.title,
      description: description ?? this.description,
      imageName: imageName ?? this.imageName,
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
    );
  }
}

class FoodWithAvgRating extends Food {
  final double rating;

  FoodWithAvgRating({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.originalPrice,
    required super.imageName,
    required this.rating,
  });

  @override
  FoodWithAvgRating copyWith({
    String? title,
    String? description,
    String? imageName,
    int? id,
    double? originalPrice,
    double? price,
    double? rating,
  }) {
    return FoodWithAvgRating(
      title: title ?? this.title,
      description: description ?? this.description,
      imageName: imageName ?? this.imageName,
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}
