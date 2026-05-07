import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_palette.dart';
import '../state/app_state.dart';
import 'home_page.dart';
import 'my_page.dart';
import 'placeholder_pages.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  bool _didAttemptOnboarding = false;

  Future<void> _maybeShowOnboarding(BuildContext context, AppState app) async {
    if (app.isOnboarded) return;
    if (!mounted) return;

    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('환영해요!'),
          content: const Text('영수증을 촬영하면 마일리지가 쌓여요.'),
          actions: [
            TextButton(
              onPressed: () async {
                await app.setOnboarded();
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('시작하기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_didAttemptOnboarding) return;
          _didAttemptOnboarding = true;
          _maybeShowOnboarding(context, app);
        });

        final pages = [
          const HomePage(),
          const PlaceholderRewardPage(),
          const MyPage(),
        ];

        return Scaffold(
          backgroundColor: AppPalette.ivoryBackground,
          body: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _TopHud(app: app),
                    Expanded(child: pages[_index]),
                    _BottomNav(
                      index: _index,
                      onChanged: (i) => setState(() => _index = i),
                    ),
                  ],
                ),
              ),
              if (app.isScanning)
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.03)),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TopHud extends StatelessWidget {
  final AppState app;
  const _TopHud({required this.app});

  static String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1D6).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFE1A8).withValues(alpha: 0.9)),
                    ),
                    child: const Icon(Icons.monetization_on, color: Color(0xFF3B2F2A), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '보유 포인트',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF6B4D2E)),
                        ),
                        Text(
                          '${_fmt(app.mileage)} P',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF3B2F2A)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFC8E6C9).withValues(alpha: 0.9)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.document_scanner_outlined, size: 18, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘 스캔',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.green.shade900.withValues(alpha: 0.75),
                              ),
                            ),
                            Text(
                              '${app.todayScanCount}회',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    child: Text(
                      'Lv.${app.level}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF3B2F2A)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.ivoryBackground,
      child: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppPalette.ivoryBackground,
        elevation: 0,
        selectedItemColor: const Color(0xFF3B2F2A),
        unselectedItemColor: const Color(0xFF6B5A53),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_outlined), label: '리워드'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이'),
        ],
        onTap: onChanged,
      ),
    );
  }
}
