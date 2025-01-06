import 'package:flutter/material.dart';

class MyBioBox extends StatelessWidget {
  const MyBioBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      child: Text(
        text,
        style: TextStyle(
          color: theme.inversePrimary,
        ),
      ),
    );
  }
}
