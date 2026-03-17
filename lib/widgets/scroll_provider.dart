import 'package:flutter/material.dart';

class ScrollProvider extends StatelessWidget {
  final Widget child;

  const ScrollProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              kToolbarHeight * 2 -
              kBottomNavigationBarHeight * 2,
        ),
        child: child,
      ),
    );
  }
}
