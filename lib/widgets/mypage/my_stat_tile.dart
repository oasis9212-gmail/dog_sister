import 'package:flutter/material.dart';

class MyStatTile extends StatelessWidget {
  final String title;
  final String valueText;
  final String unit;
  final String caption;
  final Color background;
  final Color valueColor;
  final bool unitIsPrimary;

  const MyStatTile({
    super.key,
    required this.title,
    required this.valueText,
    required this.unit,
    required this.caption,
    required this.background,
    required this.valueColor,
    this.unitIsPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                valueText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: unitIsPrimary ? const Color(0xFFE85D3A) : Colors.brown.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: unitIsPrimary ? Colors.brown.shade600 : const Color(0xFFE85D3A),
            ),
          ),
        ],
      ),
    );
  }
}
