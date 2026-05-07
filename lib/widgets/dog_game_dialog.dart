import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'background_scene.dart';
import 'dog_character.dart';

/// 강아지 키우기 — 전체 화면(100vw/100vh에 해당), 배경은 [BackgroundScene]으로 꽉 채움.
/// 상단 앱바·하단 액션은 SafeArea + Column으로 화면 끝에 고정(CSS position: fixed와 동일).
class DogGameDialog extends StatelessWidget {
  const DogGameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final maxExp = app.maxExp;
    final expProgress = maxExp <= 0 ? 0.0 : (app.exp / maxExp).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: BackgroundScene()),
          const Positioned.fill(child: Center(child: DogCharacter())),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GameTopBar(onClose: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _GameStatsSection(
                      app: app,
                      expProgress: expProgress,
                    ),
                  ),
                ),
                _GameBottomActions(app: app),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameTopBar extends StatelessWidget {
  const _GameTopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '강아지 키우기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _GameStatsSection extends StatelessWidget {
  const _GameStatsSection({
    required this.app,
    required this.expProgress,
  });

  final AppState app;
  final double expProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Lv. ${app.level}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '경험치: ${app.exp}/${app.maxExp}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: expProgress,
            minHeight: 10,
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B2F2A)),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Text(
              '행복도',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 10),
            Text('${app.happiness}%', style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (app.happiness / 100).clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6A11CB)),
          ),
        ),
        if (app.dogLastMessage.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            ),
            child: Text(
              app.dogLastMessage,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class _GameBottomActions extends StatelessWidget {
  const _GameBottomActions({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    emoji: '🍖',
                    label: '밥 주기',
                    cost: 100,
                    disabled: app.isDogActionProcessing || app.mileage < 100,
                    onPressed: () => app.performDogAction(DogAction.feed),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    emoji: '🛁',
                    label: '씻겨주기',
                    cost: 80,
                    disabled: app.isDogActionProcessing || app.mileage < 80,
                    onPressed: () => app.performDogAction(DogAction.wash),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ActionButton(
              emoji: '🎾',
              label: '놀아주기',
              cost: 50,
              disabled: app.isDogActionProcessing || app.mileage < 50,
              onPressed: () => app.performDogAction(DogAction.play),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int cost;
  final bool disabled;
  final Future<void> Function() onPressed;

  const _ActionButton({
    required this.emoji,
    required this.label,
    required this.cost,
    required this.disabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: disabled
              ? null
              : () async {
                  await onPressed();
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            foregroundColor: const Color(0xFF3B2F2A),
            elevation: 8,
            side: BorderSide(color: Colors.black.withValues(alpha: 0.06), width: 1),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                '$cost P',
                style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
