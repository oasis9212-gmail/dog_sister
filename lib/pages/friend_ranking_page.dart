import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/lovable_assets.dart';
import '../state/app_state.dart';

const _kMeId = 'me';

/// FriendRanking.tsx 참고: TOP 10 + 나머지 친구 구분, '나' 강조.
class FriendRankingPage extends StatelessWidget {
  const FriendRankingPage({super.key});

  /// 가짜 친구 14명 + 나 1명 = 15명 (정렬 후 1~10 / 11~15 구분).
  /// 친구마다 [AppState.lovableDogPngAssets]에서 시드 기반 랜덤 이미지 1장 할당.
  static List<_FriendRow> _buildMockRows(AppState app) {
    final templates = <(String id, String name, int level, int points)>[
      ('1', '김민지', 8, 12400),
      ('2', '이서준', 7, 9800),
      ('3', '박지유', 6, 8200),
      (_kMeId, '나 (바우 돌보미)', 3, 3240),
      ('4', '최윤서', 5, 6100),
      ('5', '정하준', 4, 4500),
      ('6', '강예린', 3, 3100),
      ('7', '오지호', 2, 1800),
      ('8', '한소율', 6, 7900),
      ('9', '윤도현', 5, 5200),
      ('10', '임채원', 4, 3800),
      ('11', '조민서', 3, 2900),
      ('12', '배준혁', 2, 2100),
      ('13', '서지안', 5, 5400),
      ('14', '홍유진', 4, 4200),
    ];

    return templates.map((t) {
      final id = t.$1;
      final avatar = id == _kMeId
          ? app.userDogImageAsset
          : AppState.randomLovableDogImageForFriendId(id);
      return _FriendRow(
        id: id,
        name: t.$2,
        level: t.$3,
        points: t.$4,
        avatarAsset: avatar,
      );
    }).toList();
  }

  static List<_FriendRow> _sortedWithUser(AppState app) {
    final rows = _buildMockRows(app)
        .map((r) => r.id == _kMeId
            ? _FriendRow(
                id: r.id,
                name: r.name,
                level: app.level,
                points: app.mileage,
                avatarAsset: app.userDogImageAsset,
              )
            : r)
        .toList();
    rows.sort((a, b) {
      final byLevel = b.level.compareTo(a.level);
      if (byLevel != 0) return byLevel;
      return b.points.compareTo(a.points);
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, _) {
        final sorted = _sortedWithUser(app);
        final myIndex = sorted.indexWhere((e) => e.id == _kMeId);
        final myRank = myIndex >= 0 ? myIndex + 1 : 0;

        final top10 = sorted.take(10).toList();
        final rest = sorted.skip(10).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
          children: [
            const Text(
              '바우 친구 랭킹',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3B2F2A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '친구들과 함께 레벨을 올려보세요!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B5A53),
              ),
            ),
            const SizedBox(height: 16),
            _MyRankBanner(myRank: myRank, total: sorted.length, app: app),
            const SizedBox(height: 20),
            const Text(
              '랭킹 TOP 10',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3B2F2A),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(top10.length, (i) {
              final rank = i + 1;
              final row = top10[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TopTenTile(
                  rank: rank,
                  row: row,
                ),
              );
            }),
            const SizedBox(height: 8),
            const Divider(height: 32, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Text('🐕', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '우리 강아지 친구들',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              ),
            ),
            ...rest.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RestFriendTile(row: row),
                )),
          ],
        );
      },
    );
  }
}

class _FriendRow {
  final String id;
  final String name;
  final int level;
  final int points;
  /// 에셋 경로 (예: assets/lovable_reference/dog-corgi.png)
  final String avatarAsset;

  const _FriendRow({
    required this.id,
    required this.name,
    required this.level,
    required this.points,
    required this.avatarAsset,
  });
}

class _MyRankBanner extends StatelessWidget {
  final int myRank;
  final int total;
  final AppState app;

  const _MyRankBanner({
    required this.myRank,
    required this.total,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A5C).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFF7A5C).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A5C).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: Color(0xFFFF7A5C), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내 현재 순위',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$myRank위 / $total명',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3B2F2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Lv.${app.level} · ${_formatPoints(app.mileage)}P',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown.shade600,
                  ),
                ),
              ],
            ),
          ),
          _DogProfileAvatar(assetPath: app.userDogImageAsset, size: 52),
        ],
      ),
    );
  }
}

class _TopTenTile extends StatelessWidget {
  final int rank;
  final _FriendRow row;

  const _TopTenTile({
    required this.rank,
    required this.row,
  });

  bool get _isMe => row.id == _kMeId;

  @override
  Widget build(BuildContext context) {
    final medalEmoji = switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => null,
    };

    return Container(
      decoration: BoxDecoration(
        color: _isMe ? const Color(0xFFFFF4EC) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isMe ? const Color(0xFFFF7A5C).withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.06),
          width: _isMe ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.brown.shade800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _DogProfileAvatar(assetPath: row.avatarAsset, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (medalEmoji != null) ...[
                      Text(medalEmoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        row.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isMe ? FontWeight.w900 : FontWeight.w700,
                          color: _isMe ? const Color(0xFFE85D3A) : const Color(0xFF3B2F2A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Lv.${row.level} · ${_formatPoints(row.points)}P',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestFriendTile extends StatelessWidget {
  final _FriendRow row;

  const _RestFriendTile({required this.row});

  bool get _isMe => row.id == _kMeId;

  @override
  Widget build(BuildContext context) {
    final suffix = _randomCuteSuffix(row.id);
    final emoji = _randomDogEmoji(row.id);

    return Container(
      decoration: BoxDecoration(
        color: _isMe ? const Color(0xFFFFF4EC) : Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isMe ? const Color(0xFFFF7A5C).withValues(alpha: 0.45) : Colors.black.withValues(alpha: 0.05),
          width: _isMe ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          _DogProfileAvatar(assetPath: row.avatarAsset, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        row.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isMe ? FontWeight.w900 : FontWeight.w700,
                          color: _isMe ? const Color(0xFFE85D3A) : const Color(0xFF3B2F2A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      suffix,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.brown.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Lv.${row.level}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DogProfileAvatar extends StatelessWidget {
  final String assetPath;
  final double size;

  const _DogProfileAvatar({
    required this.assetPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFFFF1D6),
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            LovableAssets.dogBowwowPng,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Text('🐶', style: TextStyle(fontSize: 22)),
          ),
        ),
      ),
    );
  }
}

String _formatPoints(int p) {
  return p.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

/// id 기준으로 안정적인 랜덤 이모지 (매 빌드마다 바뀌지 않음)
String _randomDogEmoji(String id) {
  const emojis = ['🐶', '🐕', '🦮', '🐕‍🦺', '🐾', '🦴'];
  return emojis[Random(id.hashCode).nextInt(emojis.length)];
}

String _randomCuteSuffix(String id) {
  const sfx = ['멍멍', '왈왈', '왈!', '킁킁', '헥헥', '댕댕'];
  return sfx[Random(id.hashCode * 17).nextInt(sfx.length)];
}
