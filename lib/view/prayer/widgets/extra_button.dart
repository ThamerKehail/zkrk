import 'package:flutter/material.dart';

import '../../../helper/color.dart';

class ExtraButton extends StatelessWidget {
  final String text;
  const ExtraButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: secondPrimaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
