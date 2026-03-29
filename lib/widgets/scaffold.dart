import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SharedScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const SharedScaffold({super.key, required this.navigationShell});

  @override
  State<SharedScaffold> createState() => _SharedScaffoldState();
}

class _SharedScaffoldState extends State<SharedScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            widget.navigationShell.goBranch(index),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
