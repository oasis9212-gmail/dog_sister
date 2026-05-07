import 'package:flutter/material.dart';

class ReceiptScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onPressed;

  const ReceiptScanButton({
    super.key,
    required this.isScanning,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isScanning ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          backgroundColor: Colors.white.withOpacity(0.92),
          foregroundColor: const Color(0xFF3B2F2A),
          elevation: 12,
          side: BorderSide(color: Colors.white.withOpacity(0.65), width: 1),
        ),
        child: isScanning
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF3B2F2A),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '스캔 중…',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ],
              )
            : const Text(
                '영수증 촬영',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
      ),
    );
  }
}
