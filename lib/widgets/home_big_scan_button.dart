import 'package:flutter/material.dart';

class HomeBigScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback? onPressed;

  const HomeBigScanButton({
    super.key,
    required this.isScanning,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: Ink(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A5C), Color(0xFFFF5E4D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7A5C).withValues(alpha: 0.4),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: isScanning
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3.5,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        '영수증 촬영하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '오늘의 영수증을 들려주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
