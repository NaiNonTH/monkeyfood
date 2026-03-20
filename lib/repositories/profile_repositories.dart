import 'package:monkeyfood/models/profile.dart';
import 'package:monkeyfood/models/restaurant.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class ProfileRepositories {
  late Restaurant? _restaurant;

  Future<Profile> getUserProfile() async {
    final res = await supabase
        .from('profiles')
        .select('*, restaurants(*)')
        .eq('id', supabase.auth.currentUser!.id)
        .single();

    final rrJson = res['restaurants'];

    _restaurant = rrJson != null
        ? Restaurant(
            id: rrJson['id'],
            name: rrJson['name'],
            location: rrJson['location'],
          )
        : null;

    return Profile(
      displayName: res['display_name'],
      tel: res['tel'],
      location: res['location'],
      restaurant: _restaurant,
    );
  }

  Restaurant? getUsersRestaurant() {
    try {
      return _restaurant;
    } catch (e) {
      return null;
    }
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
