import 'package:flutter/material.dart';

/// 에셋이 없거나 로드 실패해도 예외 없이 [placeholder]를 보여줍니다.
class SafeAssetImage extends StatelessWidget {
  const SafeAssetImage(
    this.assetPath, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  static Widget _defaultPlaceholder({double? w, double? h}) {
    return Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.image_not_supported_outlined, size: 28, color: Color(0xFFC4B5A8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget img = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return _defaultPlaceholder(w: width, h: height);
      },
    );

    if (borderRadius != null) {
      img = ClipRRect(
        borderRadius: borderRadius!,
        child: img,
      );
    }

    return img;
  }
}
