import 'package:monkeyfood/models/profile.dart';
import 'package:monkeyfood/models/restaurant.dart';
import 'package:monkeyfood/services/supabase_service.dart';
import 'package:random_string/random_string.dart';

class ProfileRepositories {
  Future<ProfileWithRestaurant> getUserProfile() async {
    final res = await supabase
        .from('profiles')
        .select('*, restaurants(*)')
        .eq('id', supabase.auth.currentUser!.id)
        .single();

    final rrJson = res['restaurants'];

    final restaurant = rrJson != null
        ? RestaurantWithCode(
            id: rrJson['id'],
            name: rrJson['name'],
            location: rrJson['location'],
            joinCode: rrJson['join_code'],
          )
        : null;

    return ProfileWithRestaurant(
      displayName: res['display_name'],
      tel: res['tel'],
      location: res['location'],
      restaurant: restaurant,
    );
  }

  Future<void> updateUserProfile(Profile profile) async {
    await supabase
        .from('profiles')
        .update({
          'display_name': profile.displayName,
          'tel': profile.tel,
          'location': profile.location,
        })
        .eq('id', supabase.auth.currentUser!.id);
  }

  Future<void> createRestaurant({
    required String name,
    required String location,
  }) async {
    final res = await supabase
        .from('restaurants')
        .insert({
          'name': name,
          'location': location,
          'join_code': randomAlphaNumeric(8),
        })
        .select('id');

    await supabase
        .from('profiles')
        .update({'restaurant_id': res[0]['id']})
        .eq('id', supabase.auth.currentUser!.id);
  }

  Future<void> joinRestaurant(String joinCode) async {
    final res = await supabase
        .from('restaurants')
        .select('id')
        .eq('join_code', joinCode)
        .single();

    await supabase
        .from('profiles')
        .update({'restaurant_id': res['id']})
        .eq('id', supabase.auth.currentUser!.id);
  }

  Future<void> leaveRestaurant() async {
    await supabase
        .from('profiles')
        .update({'restaurant_id': null})
        .eq('id', supabase.auth.currentUser!.id);
  }
}
