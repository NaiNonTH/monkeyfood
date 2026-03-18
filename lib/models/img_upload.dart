import 'dart:typed_data';

class ImgUpload {
  final Uint8List? bytes;
  final String name;
  final int size;

  ImgUpload({required this.bytes, required this.name, required this.size});
}
