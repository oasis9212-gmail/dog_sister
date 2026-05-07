import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/app_palette.dart';
import '../constants/home_screen_assets.dart';
import '../state/app_state.dart';
import '../widgets/homepage/home_benefit_coupon_card.dart';
import '../widgets/homepage/home_big_scan_button.dart';
import '../widgets/homepage/home_hero_dog_section.dart';
import '../widgets/homepage/home_mileage_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _cameraBusy = false;

  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> _takePhoto() async {
    if (_cameraBusy) return null;
    setState(() => _cameraBusy = true);
    try {
      return await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
    } finally {
      if (mounted) setState(() => _cameraBusy = false);
    }
  }

  Future<void> _onReceiptCameraPressed(BuildContext context) async {
    final file = await _takePhoto();
    if (!context.mounted) return;
    if (file == null) return;

    final app = context.read<AppState>();
    final result = await app.scanReceiptFromCapturedPath(file.path);
    if (!context.mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다른 스캔 처리 중입니다. 잠시 후 다시 시도해 주세요.')),
      );
      return;
    }

    final preview = result.rawText.length > 80
        ? '${result.rawText.substring(0, 80)}…'
        : result.rawText;
    final earnedMsg = result.earned > 0
        ? '+${result.earned}P · ${result.store}'
        : '금액 미인식 · ${result.store}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          preview.isEmpty ? earnedMsg : '$earnedMsg\n$preview',
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  static String _breedFromAsset(String path) {
    final file = path.split('/').last.replaceAll('.png', '');
    final key = file.startsWith('dog-') ? file.substring(4) : file;
    const labels = <String, String>{
      'beagle': '비글',
      'bichon': '비숑',
      'bowwow': '바우',
      'chihuahua': '치와와',
      'corgi': '코기',
      'golden': '골든',
      'husky': '허스키',
      'maltese': '말티즈',
      'poodle': '푸들',
      'shiba': '시바',
    };
    return labels[key] ?? '강아지';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, _) {
        final maxExp = app.maxExp;
        final expProgress = maxExp <= 0
            ? 0.0
            : (app.exp / maxExp).clamp(0.0, 1.0);
        return Scaffold(
          backgroundColor: AppPalette.ivoryBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '안녕하세요 👋',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B5A53),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '바우바우',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF3B2F2A),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '🐾',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        HomeMileageCard(
                          mileage: app.mileage,
                          level: app.level,
                          breedLabel: _breedFromAsset(app.userDogImageAsset),
                        ),
                        const SizedBox(height: 16),

                        HomeHeroDogSection(
                          app: app,
                          expProgress: expProgress,
                        ),
                        const SizedBox(height: 20),

                        HomeBigScanButton(
                          isScanning: _cameraBusy,
                          onPressed: _cameraBusy
                              ? null
                              : () => _onReceiptCameraPressed(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '오늘 스캔 ${app.todayScanCount}회 · 보유 ${_fmt(app.mileage)}P',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown.shade600,
                          ),
                        ),
                        const SizedBox(height: 22),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🎁 내 주변 혜택',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF3B2F2A),
                              ),
                            ),
                            Text(
                              '전체보기 ›',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.brown.shade500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const HomeBenefitCouponCard(
                          imageAsset: HomeScreenAssets.cafeLocal,
                          tag: '단골 혜택',
                          tagColor: Color(0xFFFFE0D4),
                          storeName: '집앞카페',
                          title: '바우카페를 4번 가셨네요!',
                          description: '한 번만 더 가시면 쿠키 서비스를 받으실 수 있어요 🍪',
                          progress: 4,
                          progressMax: 5,
                        ),
                        const SizedBox(height: 12),
                        const HomeBenefitCouponCard(
                          imageAsset: HomeScreenAssets.seafoodMarket,
                          tag: '이벤트',
                          tagColor: Color(0xFFE8F5E9),
                          storeName: '오늘수산',
                          title: '5만원 이상 구매 시',
                          description: '조개 500g 서비스! 🐚',
                          progress: null,
                          progressMax: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
