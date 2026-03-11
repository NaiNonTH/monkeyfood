import 'package:flutter/material.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';

class SharedScaffold extends StatelessWidget {
  final Widget child;

  const SharedScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const GlobalAppBar(), body: child);
  }
}
