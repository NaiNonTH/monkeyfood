abstract class ImageService {
  String get groupName => 'image';

  String? url(String? imageName) {
    if (imageName == null) return null;

    return 'https://aymxpmooklbwlnojtltx.supabase.co/storage/v1/object/public/$groupName/$imageName';
  }
}

class FoodImageService extends ImageService {
  static final FoodImageService instance = FoodImageService._();
  FoodImageService._();

  @override
  String get groupName => 'food-images';
}
