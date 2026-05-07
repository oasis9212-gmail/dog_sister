import 'dart:math';

import 'points_calculator.dart';
import 'receipt_ocr_service.dart';

class MockReceiptOcrService implements ReceiptOcrService {
  final Random _rng;

  MockReceiptOcrService({Random? rng}) : _rng = rng ?? Random();

  ScanResult _randomScanResult() {
    final stores = ['새 영수증', 'GS25', 'CU편의점', '이마트24'];
    final store = stores[_rng.nextInt(stores.length)];

    final amountWon = 10000 + _rng.nextInt(400000);
    final earned = moneyToMileagePoints(amountWon);

    return ScanResult(
      earned: earned,
      store: store,
      rawText: 'MOCK_OCR: store=$store, amountWon=$amountWon, earned=$earned',
    );
  }

  @override
  Future<ScanResult> scanAndExtractEarned() async {
    await Future.delayed(const Duration(seconds: 1));
    return _randomScanResult();
  }

  @override
  Future<ScanResult> recognizeFromImagePath(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _randomScanResult();
  }
}

