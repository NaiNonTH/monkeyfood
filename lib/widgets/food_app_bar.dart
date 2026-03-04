import 'package:flutter/material.dart';

class FoodAppBar extends AppBar {
  FoodAppBar({super.key});

  @override
  Color get backgroundColor => Colors.orangeAccent;

  @override
  Widget get title =>
      Text('MonkeyFood', style: TextStyle(fontWeight: FontWeight.bold));
}
