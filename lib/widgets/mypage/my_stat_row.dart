import 'package:flutter/material.dart';

class MyStatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool muted;

  const MyStatRow({
    super.key,
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: muted ? Colors.brown.shade500 : const Color(0xFF3B2F2A),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: muted ? Colors.brown.shade600 : const Color(0xFFE85D3A),
          ),
        ),
      ],
    );
  }
}
