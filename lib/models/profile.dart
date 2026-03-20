import 'package:monkeyfood/models/restaurant.dart';

class BaseProfile {
  final String displayName;
  final String tel;
  final String location;

  BaseProfile({
    required this.displayName,
    required this.tel,
    required this.location,
  });
}

class Profile extends BaseProfile {
  final Restaurant? restaurant;

  Profile({
    required super.displayName,
    required super.tel,
    required super.location,
    this.restaurant,
  });
}
