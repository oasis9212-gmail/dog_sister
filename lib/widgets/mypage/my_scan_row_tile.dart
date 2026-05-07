import 'package:flutter/material.dart';

import '../../state/app_state.dart';

class MyScanRowTile extends StatelessWidget {
  final ScanEntry entry;

  const MyScanRowTile({super.key, required this.entry});

  static String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.store,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B2F2A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.date,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${_fmt(entry.earned)}P',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFFE85D3A),
            ),
          ),
        ],
      ),
    );
  }
}
