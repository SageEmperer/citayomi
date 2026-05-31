import 'package:flutter/material.dart';

class GenreBadge extends StatelessWidget {
  final String text;

  const GenreBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Text(text,
          style: TextStyle(color: Colors.grey[400], fontSize: 10)),
    );
  }
}
