// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bowwow_flutter/main.dart';
import 'package:bowwow_flutter/state/app_state.dart';

void main() {
  testWidgets('MainShell builds and shows onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const BowwowApp(),
      ),
    );

    // MainShell의 post-frame callback에서 온보딩 다이얼로그를 띄웁니다.
    // 애니메이션/다이얼로그 때문에 pumpAndSettle 대신 짧게 pump.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('환영해요!'), findsOneWidget);
  });
}
