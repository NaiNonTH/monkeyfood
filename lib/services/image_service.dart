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
    try {
      final fullPath = await supabase.storage
          .from(groupName)
          .uploadBinary(path, bytes, fileOptions: FileOptions(upsert: false));
      return fullPath;
    } catch (e) {
      // Check if the error is a duplicate file error
      if (e.toString().contains('The resource already exists')) {
        final newPath = _appendRandomSuffix(path);
        return uploadBinary(newPath, bytes); // Retry with new name
      }
      rethrow; // Re-throw if it's a different error
    }
  }

  String _appendRandomSuffix(String path) {
    final dotIndex = path.lastIndexOf('.');

    // Generate a short random string
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(
      9,
    );

    if (dotIndex != -1) {
      // Insert suffix before the extension: "file.png" → "file_3.png"
      return '${path.substring(0, dotIndex)}_$suffix${path.substring(dotIndex)}';
    } else {
      // No extension: "file" → "file_3"
      return '${path}_$suffix';
    }
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
