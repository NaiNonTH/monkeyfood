import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final String message;

  const ShowError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Something went wrong: $message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
