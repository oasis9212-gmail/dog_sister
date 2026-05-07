import 'package:flutter/material.dart';

/// MainShell·게임 화면 중앙 캐릭터 — 정적 PNG만 표시 (애니메이션 없음)
class DogCharacter extends StatelessWidget {
  const DogCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Image.asset(
        'assets/lovable_reference/dog-bowwow.png',
        width: 280,
        height: 280,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
    );
  }
}
