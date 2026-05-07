class ScanResult {
  final int earned; // 마일리지(포인트) 증가량
  final String store; // 매장명(간단 분류)
  final String rawText; // 디버깅용 OCR 원문

  const ScanResult({
    required this.earned,
    required this.store,
    required this.rawText,
  });
}

abstract class ReceiptOcrService {
  /// 영수증 이미지에서 결제금액을 찾아 마일리지로 변환합니다.
  Future<ScanResult> scanAndExtractEarned();

  /// 이미 촬영·저장된 이미지 파일 경로에서 텍스트를 읽고 영수증으로 파싱합니다.
  Future<ScanResult> recognizeFromImagePath(String imagePath);
}

