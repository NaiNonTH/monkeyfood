import 'package:monkeyfood/models/food_entry.dart';

class FoodEntryState {
  final List<FoodEntry> foodEntries;

  FoodEntryState({required this.foodEntries});

  FoodEntryState copyWith({List<FoodEntry>? foodEntries}) {
    return FoodEntryState(foodEntries: foodEntries ?? this.foodEntries);
  }
}
