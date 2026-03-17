import 'package:flutter/material.dart';

class LineBox extends StatelessWidget {
  final Widget child;

  const LineBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(width: 1, color: Colors.grey[400]!),
        ),
      ),
      child: child,
    );
  }
}
