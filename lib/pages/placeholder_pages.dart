import 'package:flutter/material.dart';

class PlaceholderRankingPage extends StatelessWidget {
  const PlaceholderRankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
      children: const [
        Text(
          '랭킹',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF3B2F2A),
          ),
        ),
        SizedBox(height: 12),
        Text(
          '친구들과 마일리지 랭킹을 곧 볼 수 있어요.',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B4D2E),
          ),
        ),
      ],
    );
  }
}

class PlaceholderRewardPage extends StatelessWidget {
  const PlaceholderRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '여기가 리워드입니다.xxx',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B2F2A),
        ),
      ),
    );
  }
}
