import 'lovable_assets.dart';

/// 홈 화면 전용 별칭 — 경로는 [LovableAssets]와 동일합니다.
abstract final class HomeScreenAssets {
  static const String cafeLocal = LovableAssets.cafeLocalPng;
  static const String seafoodMarket = LovableAssets.seafoodMarketPng;
  static const String homeBanner = LovableAssets.homeBannerPng;

  static const List<String> optionalDecorations = [
    homeBanner,
  ];
}
