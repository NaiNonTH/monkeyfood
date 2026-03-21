import 'package:monkeyfood/models/restaurant.dart';

class Profile {
  final String displayName;
  final String tel;
  final String location;

  Profile({
    required this.displayName,
    required this.tel,
    required this.location,
  });
}

class ProfileWithRestaurant extends Profile {
  final RestaurantWithCode? restaurant;

  ProfileWithRestaurant({
    required super.displayName,
    required super.tel,
    required super.location,
    this.restaurant,
  });
}
