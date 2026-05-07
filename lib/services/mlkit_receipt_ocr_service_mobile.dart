import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'points_calculator.dart';
import 'receipt_ocr_service.dart';
import 'receipt_text_parser.dart';

class MlKitReceiptOcrService implements ReceiptOcrService {
  final ReceiptOcrService fallback;

  /// OCR 실패/권한/취소 등에서도 앱 흐름이 끊기지 않게 하는 폴백.
  MlKitReceiptOcrService({required this.fallback});

  Future<String> _readRawText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognized =
          await textRecognizer.processImage(inputImage);
      return recognized.text;
    } finally {
      await textRecognizer.close();
    }
  }

  @override
  Future<ScanResult> scanAndExtractEarned() async {
    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: ImageSource.camera);

      if (xfile == null) {
        return fallback.scanAndExtractEarned();
      }

      final raw = await _readRawText(xfile.path);

      final amountWon = ReceiptTextParser.extractPaymentAmountWon(raw);
      if (amountWon == null) {
        return fallback.scanAndExtractEarned();
      }

      final earned = moneyToMileagePoints(amountWon);
      final store = ReceiptTextParser.detectStore(raw);
      return ScanResult(earned: earned, store: store, rawText: raw);
    } catch (_) {
      return fallback.scanAndExtractEarned();
    }
  }

  @override
  Future<ScanResult> recognizeFromImagePath(String imagePath) async {
    try {
      final raw = await _readRawText(imagePath);
      if (raw.trim().isEmpty) {
        return const ScanResult(
          earned: 0,
          store: '인식 실패',
          rawText: '',
        );
      }
      return ReceiptTextParser.scanResultFromRecognizedText(raw);
    } catch (_) {
      return const ScanResult(
        earned: 0,
        store: '인식 실패',
        rawText: '',
      );
    }
  }
}
