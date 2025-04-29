import 'package:flutter/material.dart';

import '../../../helper/color.dart';

class PrayerTile extends StatelessWidget {
  final String title;
  final String time;
  final String subtitle;

  final bool highlight;

  const PrayerTile({
    super.key,
    required this.title,
    required this.time,
    required this.subtitle,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondPrimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
