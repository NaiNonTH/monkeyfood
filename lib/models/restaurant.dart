class Restaurant {
  final int id;
  final String name;
  final String location;

  Restaurant({required this.id, required this.name, required this.location});
}

class RestaurantWithCode extends Restaurant {
  final String joinCode;

  RestaurantWithCode({
    required super.id,
    required super.name,
    required super.location,
    required this.joinCode,
  });
}
