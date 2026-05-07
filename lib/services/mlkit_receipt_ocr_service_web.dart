import 'receipt_ocr_service.dart';

/// 웹(Chrome)에서는 ML Kit OCR이 정상 동작/컴파일이 어려울 수 있어,
/// 항상 가짜(동작용) 결과로 우회합니다.
class MlKitReceiptOcrService implements ReceiptOcrService {
  final ReceiptOcrService fallback;

  /// OCR 실패/권한/취소 등에서도 앱 흐름이 끊기지 않게 하는 폴백.
  MlKitReceiptOcrService({required this.fallback});

  @override
  Future<ScanResult> scanAndExtractEarned() async {
    // DogGame/스캔 플로우 데모를 위해 웹에서는 고정 +1240P를 넣습니다.
    // (ScanFlow.tsx를 참고한 "가짜 포인트" 처리의 임시 구현)
    return const ScanResult(
      earned: 1240,
      store: '웹 모의 영수증',
      rawText: 'WEB_MOCK_OCR: +1240P',
    );
  }

  @override
  Future<ScanResult> recognizeFromImagePath(String imagePath) async {
    return ScanResult(
      earned: 1240,
      store: '웹 모의 영수증',
      rawText:
          'WEB_MOCK_OCR: 크롬에서는 ML Kit 로컬 OCR 대신 데모 텍스트입니다. path=$imagePath',
    );
  }
}

