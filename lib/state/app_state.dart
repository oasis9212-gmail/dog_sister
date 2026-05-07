import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/lovable_assets.dart';
import '../services/mlkit_receipt_ocr_service.dart';
import '../services/mock_receipt_ocr_service.dart';
import '../services/receipt_ocr_service.dart';

class ScanEntry {
  final String date; // yyyy-MM-dd
  final int earned; // 마일리지 증가량
  final int amountWon; // 결제금액(원) - OCR 원문에서 추출한 값을 남기고 싶을 때 사용
  final String store;

  const ScanEntry({
    required this.date,
    required this.earned,
    required this.amountWon,
    required this.store,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'earned': earned,
        'amountWon': amountWon,
        'store': store,
      };

  factory ScanEntry.fromJson(Map<String, dynamic> json) => ScanEntry(
        date: json['date'] as String,
        earned: (json['earned'] as num).toInt(),
        amountWon: (json['amountWon'] as num).toInt(),
        store: json['store'] as String,
      );
}

enum DogAction {
  feed,
  wash,
  play,
}

/// `assets/lovable_reference/` 안의 강아지 PNG 목록 (Lovable / FriendRanking.tsx 품종 기준).
/// 실제 파일은 프로젝트 폴더에 추가하면 됩니다.
class AppState extends ChangeNotifier {
  static const List<String> lovableDogPngAssets = [
    'assets/lovable_reference/dog-beagle.png',
    'assets/lovable_reference/dog-bichon.png',
    'assets/lovable_reference/dog-bowwow.png',
    'assets/lovable_reference/dog-chihuahua.png',
    'assets/lovable_reference/dog-corgi.png',
    'assets/lovable_reference/dog-golden.png',
    'assets/lovable_reference/dog-husky.png',
    'assets/lovable_reference/dog-maltese.png',
    'assets/lovable_reference/dog-poodle.png',
    'assets/lovable_reference/dog-shiba.png',
  ];

  /// 가짜 랭킹 친구(id)마다 항상 같은 이미지가 나가도록 시드 고정.
  static String randomLovableDogImageForFriendId(String friendId) {
    const list = lovableDogPngAssets;
    if (list.isEmpty) return LovableAssets.dogBowwowPng;
    final i = Random(friendId.hashCode).nextInt(list.length);
    return list[i];
  }

  static const _kOnboarded = 'bowwow_onboarded';
  static const _kMileage = 'bowwow_mileage';
  static const _kScanHistory = 'bowwow_scan_history';

  static const _kDogLevel = 'bowwow_dog_level';
  static const _kDogExp = 'bowwow_dog_exp';
  static const _kDogHappiness = 'bowwow_dog_happiness';
  /// 사용자가 선택한 강아지 이미지(에셋 경로). 랭킹의 '나' 프로필에만 사용.
  static const _kUserDogImageAsset = 'bowwow_user_dog_image';
  /// 마이페이지에 표시할 강아지/호칭 이름.
  static const _kDogDisplayName = 'bowwow_dog_display_name';

  final ReceiptOcrService _ocr = MlKitReceiptOcrService(
    fallback: MockReceiptOcrService(),
  );

  bool _isOnboarded = false;
  bool _isScanning = false;

  int _mileage = 1240;
  int _level = 3; // 강아지 레벨(게임 로직 기준)

  int _dogExp = 0;
  int _dogHappiness = 70;
  bool _isDogActionProcessing = false;

  /// 사용자가 고른 강아지 PNG 경로 (미설정 시 [userDogImageAsset] 기본값 사용).
  String? _userDogImageAsset;

  /// 마이페이지 등에 표시 (기본: 바우 돌보미).
  String _dogDisplayName = '바우 돌보미';

  final List<ScanEntry> _scanHistory = [];

  bool get isOnboarded => _isOnboarded;
  bool get isScanning => _isScanning;
  bool get isDogActionProcessing => _isDogActionProcessing;

  int get mileage => _mileage;
  int get level => _level;
  int get exp => _dogExp;
  int get happiness => _dogHappiness;
  int get maxExp => _level * 100;

  /// DogGame.tsx의 speech bubble에 해당하는 마지막 메시지입니다.
  /// (간단 구현이라서 애니메이션/타이머는 UI에서 처리하지 않고 상태로만 유지합니다.)
  String _dogLastMessage = '';
  String get dogLastMessage => _dogLastMessage;

  /// 마이페이지·프로필에 쓰는 이름.
  String get dogDisplayName => _dogDisplayName;

  Future<void> setDogDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _dogDisplayName = trimmed.length > 24 ? trimmed.substring(0, 24) : trimmed;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kDogDisplayName, _dogDisplayName);
    } catch (_) {}
    notifyListeners();
  }

  /// 영수증 스캔으로 쌓인 기록 개수.
  int get totalScanCount => _scanHistory.length;

  /// 오늘(로컬 날짜) 스캔한 횟수.
  int get todayScanCount {
    final today = _todayYmd();
    return _scanHistory.where((e) => e.date == today).length;
  }

  /// 랭킹/프로필에서 '나'에게 쓰는 고정 강아지 이미지.
  String get userDogImageAsset {
    final saved = _userDogImageAsset;
    if (saved != null && lovableDogPngAssets.contains(saved)) {
      return saved;
    }
    // 기본: 바우( bowwow ) 이미지가 목록에 있으면 그걸, 없으면 첫 번째.
    try {
      return lovableDogPngAssets.firstWhere(
        (p) => p.contains('dog-bowwow'),
      );
    } catch (_) {
      return lovableDogPngAssets.isNotEmpty
          ? lovableDogPngAssets.first
          : LovableAssets.dogBowwowPng;
    }
  }

  /// 품종 선택 UI 등에서 호출. [assetPath]는 [lovableDogPngAssets] 중 하나여야 합니다.
  Future<void> setUserDogImageAsset(String assetPath) async {
    if (!lovableDogPngAssets.contains(assetPath)) return;
    _userDogImageAsset = assetPath;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kUserDogImageAsset, assetPath);
    } catch (_) {}
    notifyListeners();
  }

  List<ScanEntry> get scanHistory => List.unmodifiable(_scanHistory);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isOnboarded = prefs.getBool(_kOnboarded) ?? false;
      _mileage = prefs.getInt(_kMileage) ?? 1240;
      // 기존(마일리지 기반) 동작과의 호환을 위해,
      // 저장된 강아지 레벨이 없으면 마일리지로부터 초기 레벨을 추정합니다.
      _level = prefs.getInt(_kDogLevel) ?? _calcLevelFromMileage(_mileage);
      _dogExp = prefs.getInt(_kDogExp) ?? 0;
      _dogHappiness = prefs.getInt(_kDogHappiness) ?? 70;
      _userDogImageAsset = prefs.getString(_kUserDogImageAsset);
      _dogDisplayName = prefs.getString(_kDogDisplayName) ?? '바우 돌보미';

      final raw = prefs.getString(_kScanHistory);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _scanHistory
          ..clear()
          ..addAll(decoded.map((e) => ScanEntry.fromJson(e as Map<String, dynamic>)));
        // 최신이 앞으로 오도록
        _scanHistory.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (_) {
      // 웹에서 로컬 저장소(localStorage) 접근 실패 등으로도
      // 앱 화면 자체는 열리게 폴백 처리합니다.
    }

    notifyListeners();
  }

  Future<void> setOnboarded() async {
    _isOnboarded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboarded, true);
    } catch (_) {
      // 저장 실패해도 UI 흐름은 계속되게 합니다.
    }
    notifyListeners();
  }

  int _calcLevelFromMileage(int mileage) {
    // 초기값(1240 -> 레벨 3)에 맞춘 단순 레벨 규칙
    return (mileage ~/ 600) + 1;
  }

  String _todayYmd() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _persistScanResult(ScanResult result) async {
    final entry = ScanEntry(
      date: _todayYmd(),
      earned: result.earned,
      amountWon: 0,
      store: result.store,
    );

    _mileage += entry.earned;

    _scanHistory.insert(0, entry);
    if (_scanHistory.length > 30) _scanHistory.removeRange(30, _scanHistory.length);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kMileage, _mileage);
      await prefs.setString(
        _kScanHistory,
        jsonEncode(_scanHistory.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      // 저장 실패해도 앱은 계속 동작해야 합니다.
    }
  }

  Future<void> scanReceiptPressed() async {
    if (_isScanning) return;

    _isScanning = true;
    notifyListeners();

    try {
      final result = await _ocr.scanAndExtractEarned();
      await _persistScanResult(result);
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  /// 홈에서 카메라로 찍은 [imagePath]에 대해 ML Kit OCR 후 스캔 기록·마일리지를 반영합니다.
  /// 다른 스캔이 진행 중이면 `null`을 반환합니다.
  Future<ScanResult?> scanReceiptFromCapturedPath(String imagePath) async {
    if (_isScanning) return null;

    _isScanning = true;
    notifyListeners();

    try {
      final result = await _ocr.recognizeFromImagePath(imagePath);
      await _persistScanResult(result);
      return result;
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> performDogAction(DogAction action) async {
    if (_isDogActionProcessing) return;

    late final int cost;
    late final int expDelta;
    const happinessDelta = 10; // DogGame.tsx의 setHappiness(prev + 10)
    late final String message;

    switch (action) {
      case DogAction.feed:
        cost = 100;
        expDelta = 30;
        message = '냠냠! 맛있게 먹고 있어요!';
        break;
      case DogAction.wash:
        cost = 80;
        expDelta = 20;
        message = '깨끗해져서 기분 좋아요!';
        break;
      case DogAction.play:
        cost = 50;
        expDelta = 15;
        message = '신나게 놀았어요! 꼬리 살랑~';
        break;
    }

    if (_mileage < cost) return;

    _isDogActionProcessing = true;
    notifyListeners();

    try {
      _mileage -= cost;
      _dogHappiness = (_dogHappiness + happinessDelta).clamp(0, 100);

      final maxExpNow = maxExp;
      _dogExp += expDelta;
      if (maxExpNow > 0 && _dogExp >= maxExpNow) {
        _dogExp = 0;
        _level += 1;
        _dogLastMessage = '레벨 업! $message';
      } else {
        _dogLastMessage = message;
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_kMileage, _mileage);
        await prefs.setInt(_kDogLevel, _level);
        await prefs.setInt(_kDogExp, _dogExp);
        await prefs.setInt(_kDogHappiness, _dogHappiness);
      } catch (_) {
        // 저장 실패해도 상태 변경은 유지합니다.
      }
    } finally {
      _isDogActionProcessing = false;
      notifyListeners();
    }
  }
}

