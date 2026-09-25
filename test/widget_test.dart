import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghanima/main.dart';
import 'package:ghanima/features/splash/presentation/screens/placeholder_screen.dart';

void main() {
  testWidgets('Splash shows brand name and tagline, then navigates',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('تموينات غنيمة'), findsOneWidget);
    expect(find.text('كل اللي تحتاجه، أقرب لك.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('تم تحميل التطبيق بنجاح'), findsOneWidget);
  });

  testWidgets('Placeholder screen shows success message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlaceholderScreen()));
    expect(find.text('تم تحميل التطبيق بنجاح'), findsOneWidget);
  });
}