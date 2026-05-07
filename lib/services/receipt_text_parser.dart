import 'points_calculator.dart';
import 'receipt_ocr_service.dart';

/// ML Kit 등으로 얻은 영수증 원문에서 매장명·결제금액을 추출합니다.
class ReceiptTextParser {
  static String detectStore(String text) {
    final t = text.replaceAll(' ', '');

    if (t.contains('GS25')) return 'GS25';
    if (t.contains('CU')) return 'CU편의점';
    if (t.contains('이마트24') || t.contains('이마트')) return '이마트24';

    return '새 영수증';
  }

  /// 영수증 텍스트에서 "결제금액(원)"으로 보이는 숫자를 뽑습니다.
  static int? extractPaymentAmountWon(String text) {
    if (text.trim().isEmpty) return null;

    final normalized = text
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final labelPattern = RegExp(
      r'(?:(결제금액|총\s*결제금액|청구금액|총\s*청구금액|승인금액|총액|합계)\s*[:\-]?\s*|(?:총\s*결제\s*금액|총\s*청구\s*금액)\s*[:\-]?\s*)(\d{1,3}(?:,\d{3})*|\d+)\s*원',
      caseSensitive: false,
    );

    final labelMatch = labelPattern.firstMatch(normalized);
    if (labelMatch != null) {
      final amountRaw = labelMatch.group(2);
      if (amountRaw != null) {
        return int.tryParse(amountRaw.replaceAll(',', ''));
      }
    }

    final moneyMatches =
        RegExp(r'(\d{1,3}(?:,\d{3})*|\d+)\s*원').allMatches(normalized);
    if (moneyMatches.isEmpty) return null;

    final values = <int>[];
    for (final m in moneyMatches) {
      final s = m.group(1);
      if (s == null) continue;
      final v = int.tryParse(s.replaceAll(',', ''));
      if (v == null) continue;
      if (v >= 1000) values.add(v);
    }

    if (values.isEmpty) return null;
    return values.last;
  }

  /// 금액을 찾으면 마일리지까지 계산하고, 못 찾으면 `earned: 0`으로 둡니다.
  static ScanResult scanResultFromRecognizedText(String raw) {
    final store = detectStore(raw);
    final amountWon = extractPaymentAmountWon(raw);
    if (amountWon == null) {
      return ScanResult(earned: 0, store: store, rawText: raw);
    }
    final earned = moneyToMileagePoints(amountWon);
    return ScanResult(earned: earned, store: store, rawText: raw);
  }
}
