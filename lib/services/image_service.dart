import 'dart:typed_data';

import 'package:monkeyfood/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ImageService {
  String get groupName => 'image';

  String? url(String? imageName) {
    if (imageName == null) return null;

    final base = supabase.storage.from(groupName).getPublicUrl(imageName);

    return '$base?t=${DateTime.now().millisecondsSinceEpoch}'; // cache busting
  }

  Future<String> uploadBinary(String path, Uint8List bytes) async {
    final fullPath = await supabase.storage
        .from(groupName)
        .uploadBinary(path, bytes, fileOptions: FileOptions(upsert: false));

    return fullPath;
  }

  Future<void> updateBinary(String path, Uint8List bytes) async {
    await supabase.storage
        .from(groupName)
        .updateBinary(
          path,
          bytes,
          fileOptions: const FileOptions(cacheControl: '0', upsert: true),
        );
  }
}

class FoodImageService extends ImageService {
  static final FoodImageService instance = FoodImageService._();
  FoodImageService._();

  @override
  String get groupName => 'food-images';
}
