// NOTE: Flutter 웹 환경에서는 ML Kit(TextRecognizer/InputImage) 의존성이
// 컴파일 단계에서 깨질 수 있어, 플랫폼별 구현을 분리합니다.
//
// - 웹: `*_web.dart` (Mock/폴백 위임)
// - 모바일: `*_mobile.dart` (기존 ML Kit OCR 로직)
export 'mlkit_receipt_ocr_service_web.dart'
    if (dart.library.io) 'mlkit_receipt_ocr_service_mobile.dart';

