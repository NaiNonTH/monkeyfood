import 'package:flutter/material.dart';
import 'package:monkeyfood/services/navigation.dart';

class GlobalAppBar extends AppBar {
  GlobalAppBar({super.key});

  @override
  Color get backgroundColor => Colors.orangeAccent;

  @override
  Widget get title =>
      Text('MonkeyFood', style: TextStyle(fontWeight: FontWeight.bold));

  @override
  List<Widget>? get actions => [
    IconButton(
      icon: Icon(Icons.shopping_cart),
      onPressed: () {
        // Handle cart action
        Navigator.of(
          NavigationService.navigatorKey.currentContext!,
        ).pushNamed('/cart');
      },
    ),
    IconButton(
      icon: Icon(Icons.account_circle),
      onPressed: () {
        // Handle profile action
        Navigator.of(
          NavigationService.navigatorKey.currentContext!,
        ).pushNamed('/profile');
      },
    ),
  ];
}
