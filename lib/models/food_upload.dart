import 'package:monkeyfood/models/img_upload.dart';

class FoodUpload {
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final ImgUpload upload;

  FoodUpload({
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.upload,
  });
}

class FoodEdit {
  final String title;
  final String description;
  final double price;
  final double originalPrice;

  FoodEdit({
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
  });
}
