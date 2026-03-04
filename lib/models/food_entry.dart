class FoodEntry {
  final String title;
  final String? imageUrl;
  final int id;
  final int originalPrice;
  final int price;
  final double rating;

  FoodEntry({
    required this.title,
    required this.price,
    required this.rating,
    required this.originalPrice,
    required this.id,
    this.imageUrl,
  });

  FoodEntry copyWith({
    String? title,
    String? imageUrl,
    int? id,
    int? originalPrice,
    int? price,
    double? rating,
  }) {
    return FoodEntry(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}
