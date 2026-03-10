class Food {
  final String title;
  final String description;
  final String? imageUrl;
  final int id;
  final int originalPrice;
  final int price;
  final double rating;

  Food({
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.originalPrice,
    required this.id,
    this.imageUrl,
  });

  Food copyWith({
    String? title,
    String? description,
    String? imageUrl,
    int? id,
    int? originalPrice,
    int? price,
    double? rating,
  }) {
    return Food(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}
