import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
        child: Image.asset('assets/images/logo.png'),
      ),
      title: const Text(
        'MonkeyFood',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.push('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
