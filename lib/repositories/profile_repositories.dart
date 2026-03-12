import 'package:monkeyfood/models/profile.dart';
import 'package:monkeyfood/services/supabase_service.dart';

class ProfileRepositories {
  Future<Profile?> getUserProfile() async {
    if (supabase.auth.currentUser == null) return null;

    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', supabase.auth.currentUser!.id)
        .single();

    return Profile(
      displayName: res['display_name'],
      tel: res['tel'],
      location: res['location'],
    );
  }
}
