import 'package:flutter/material.dart';

class HomeMileageCard extends StatelessWidget {
  final int mileage;
  final int level;
  final String breedLabel;

  const HomeMileageCard({
    super.key,
    required this.mileage,
    required this.level,
    required this.breedLabel,
  });

  static String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내 마일리지',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _fmt(mileage),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3B2F2A),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'P',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF7A5C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Lv.$level · $breedLabel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade500,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 88,
              height: 88,
              child: Image.asset(
                'assets/lovable_reference/dog-bowwow.png',
                fit: BoxFit.contain,
                width: 88,
                height: 88,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
