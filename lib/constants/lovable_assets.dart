/// 모든 Lovable 이미지는 `assets/lovable_reference/` 아래에 둡니다.
abstract final class LovableAssets {
  static const String _root = 'assets/lovable_reference';

  /// 메인/기본 강아지 PNG
  static const String dogBowwowPng = '$_root/dog-bowwow.png';

  /// 홈 쿠폰 카드 (HomeScreen.tsx)
  static const String cafeLocalPng = '$_root/cafe-local.png';
  static const String seafoodMarketPng = '$_root/seafood-market.png';

  /// (선택) 홈 상단 배너
  static const String homeBannerPng = '$_root/home-banner.png';

  /// 배경 위 떠다니는 강아지 SVG
  static const String dogBlinkSvg = '$_root/dog_blink.svg';
  static const String dogOpenSvg = '$_root/dog_open.svg';
}
