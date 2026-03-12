class Food {
  final String title;
  final String description;
  final String? imageName;
  final int id;
  final double originalPrice;
  final double price;
  final double rating;

  Food({
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.id,
    this.rating = 5.00,
    this.imageName,
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
      rating: rating ?? this.rating,
    );
  }
}
