import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghanima/main.dart';
import 'package:ghanima/features/home/presentation/screens/home_screen.dart';
import 'package:ghanima/features/splash/presentation/screens/placeholder_screen.dart';

void main() {
  testWidgets('Splash shows brand then navigates to Home', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('تموينات غنيمة'), findsOneWidget);
    expect(find.text('كل اللي تحتاجه، أقرب لك.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Placeholder screen shows success message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlaceholderScreen()));
    expect(find.text('تم تحميل التطبيق بنجاح'), findsOneWidget);
  });
}