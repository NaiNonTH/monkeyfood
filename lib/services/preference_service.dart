import 'dart:convert';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  late final SharedPreferencesWithCache _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {'favorite_items'},
      ),
    );
  }

  List<Map<String, dynamic>> getFavoriteItems() {
    final jsonString = _prefs.getString('favorite_items');

    if (jsonString == null) return [];

    final result = jsonDecode(jsonString) as List;

    return result.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> addFavoriteItem(Map<String, dynamic> favoriteItem) async {
    final jsonString = getFavoriteItems();

    jsonString.add(favoriteItem);

    final json = jsonEncode(jsonString);

    await _prefs.setString('favorite_items', json);
  }

  Future<void> removeFavoriteItem(int id) async {
    final jsonString = getFavoriteItems();

    jsonString.removeWhere((favoriteItem) => favoriteItem['id'] == id);

    final json = jsonEncode(jsonString);

    await _prefs.setString('favorite_items', json);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

final preferenceService = PreferenceService();
