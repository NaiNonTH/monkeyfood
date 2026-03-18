import 'package:monkeyfood/services/supabase_service.dart';

abstract class ImageService {
  String get groupName => 'image';

  String? url(String? imageName) {
    if (imageName == null) return null;

    return supabase.storage.from('food-images').getPublicUrl(imageName);
  }
}

class FoodImageService extends ImageService {
  static final FoodImageService instance = FoodImageService._();
  FoodImageService._();

  @override
  String get groupName => 'food-images';
}
