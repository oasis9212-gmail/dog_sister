import 'package:flutter/material.dart';

import '../../constants/lovable_assets.dart';

class MyBreedAvatarButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const MyBreedAvatarButton({
    super.key,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4EC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFE1C7)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    LovableAssets.dogBowwowPng,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Text('🐶', style: TextStyle(fontSize: 36))),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7A5C),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('✏️', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
