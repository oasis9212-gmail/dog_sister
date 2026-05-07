import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/lovable_assets.dart';
import '../state/app_state.dart';

/// MyPage.tsx 스타일 — 카드 레이아웃, 품종(이미지) 선택, 스캔 내역.
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  static String _breedLabelFromAsset(String path) {
    final file = path.split('/').last.replaceAll('.png', '');
    final key = file.startsWith('dog-') ? file.substring(4) : file;
    const labels = <String, String>{
      'beagle': '비글',
      'bichon': '비숑 프리제',
      'bowwow': '바우',
      'chihuahua': '치와와',
      'corgi': '웰시 코기',
      'golden': '골든 리트리버',
      'husky': '허스키',
      'maltese': '말티즈',
      'poodle': '푸들',
      'shiba': '시바',
    };
    return labels[key] ?? key;
  }

  static String _formatInt(int n) {
    return n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  /// 가짜 기부 사료(kg) — 스캔 횟수에 비례해 증가하는 데모 값.
  static double _fakeDonatedKg(int scanCount) {
    return (12.5 + scanCount * 0.35).clamp(0, 99.9);
  }

  /// 가짜 "이번 달" 스캔 횟수.
  static int _fakeMonthScanCount(int total) {
    if (total <= 0) return 0;
    return (total % 8) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, _) {
        final breedLabel = _breedLabelFromAsset(app.userDogImageAsset);
        final scans = app.scanHistory;
        final donated = _fakeDonatedKg(app.totalScanCount);
        final monthFake = _fakeMonthScanCount(app.totalScanCount);
        final meals = (donated / 0.5).floor();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '마이페이지',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3B2F2A),
                    ),
                  ),
                ),
                Material(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showEditNameDialog(context, app),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.settings_outlined, color: Color(0xFF6B5A53)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 프로필 카드
            _CardShell(
              child: Row(
                children: [
                  _BreedAvatarButton(
                    imageAsset: app.userDogImageAsset,
                    onTap: () => _openBreedPicker(context, app),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.dogDisplayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3B2F2A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Lv.${app.level} · $breedLabel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '총 포인트 ${_formatInt(app.mileage)} P',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE85D3A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 통계 그리드
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    title: '기부한 사료',
                    valueText: donated.toStringAsFixed(1),
                    unit: 'kg',
                    caption: '🐾 바우 ${meals}끼 분량',
                    background: const Color(0xFFFF7A5C).withValues(alpha: 0.12),
                    valueColor: const Color(0xFF3B2F2A),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatTile(
                    title: '총 적립 포인트',
                    valueText: _formatInt(app.mileage),
                    unit: 'P',
                    caption: '이번 달 활동',
                    background: const Color(0xFFB8E6C8).withValues(alpha: 0.45),
                    valueColor: const Color(0xFF3B2F2A),
                    unitIsPrimary: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 스캔 통계 (실제 + 가짜 보조)
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '스캔 통계',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3B2F2A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StatRow(label: '누적 영수증 스캔', value: '${app.totalScanCount}회'),
                  const Divider(height: 20),
                  _StatRow(
                    label: '이번 달 스캔 (데모)',
                    value: '$monthFake회',
                    muted: true,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '※ 이번 달 수치는 UI 데모용 가짜 데이터입니다.',
                    style: TextStyle(fontSize: 11, color: Colors.brown.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              '최근 영수증 기록',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3B2F2A),
              ),
            ),
            const SizedBox(height: 12),
            if (scans.isEmpty)
              _CardShell(
                child: Text(
                  '아직 스캔 기록이 없어요. 홈에서 영수증을 스캔해 보세요!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade600,
                  ),
                ),
              )
            else
              ...scans.take(8).map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ScanRowTile(entry: e),
                    ),
                  ),
          ],
        );
      },
    );
  }

  static void _openBreedPicker(BuildContext context, AppState app) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(ctx).bottom + 16,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '나만의 강아지 선택',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'PNG 이미지가 폴더에 있어야 보입니다.',
                style: TextStyle(fontSize: 12, color: Colors.brown.shade600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: AppState.lovableDogPngAssets.length,
                  itemBuilder: (context, i) {
                    final path = AppState.lovableDogPngAssets[i];
                    final selected = app.userDogImageAsset == path;
                    final label = _breedLabelFromAsset(path);
                    return Material(
                      color: selected
                          ? const Color(0xFFFF7A5C).withValues(alpha: 0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await app.setUserDogImageAsset(path);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text('🐶', style: TextStyle(fontSize: 32)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: selected ? const Color(0xFFE85D3A) : const Color(0xFF3B2F2A),
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle, color: Color(0xFFE85D3A), size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showEditNameDialog(BuildContext context, AppState app) {
    final controller = TextEditingController(text: app.dogDisplayName);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('이름 수정'),
          content: TextField(
            controller: controller,
            maxLength: 24,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[\n\r]'))],
            decoration: const InputDecoration(
              hintText: '강아지/호칭 이름',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
            FilledButton(
              onPressed: () async {
                await app.setDogDisplayName(controller.text);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: child,
    );
  }
}

class _BreedAvatarButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _BreedAvatarButton({
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

class _StatTile extends StatelessWidget {
  final String title;
  final String valueText;
  final String unit;
  final String caption;
  final Color background;
  final Color valueColor;
  final bool unitIsPrimary;

  const _StatTile({
    required this.title,
    required this.valueText,
    required this.unit,
    required this.caption,
    required this.background,
    required this.valueColor,
    this.unitIsPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                valueText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: unitIsPrimary ? const Color(0xFFE85D3A) : Colors.brown.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: unitIsPrimary ? Colors.brown.shade600 : const Color(0xFFE85D3A),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool muted;

  const _StatRow({
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: muted ? Colors.brown.shade500 : const Color(0xFF3B2F2A),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: muted ? Colors.brown.shade600 : const Color(0xFFE85D3A),
          ),
        ),
      ],
    );
  }
}

class _ScanRowTile extends StatelessWidget {
  final ScanEntry entry;

  const _ScanRowTile({required this.entry});

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
            '+${MyPage._formatInt(entry.earned)}P',
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
