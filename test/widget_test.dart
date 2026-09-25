import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghanima/core/widgets/shell_screen.dart';
import 'package:ghanima/features/auth/presentation/screens/auth_screen.dart';
import 'package:ghanima/features/splash/presentation/screens/placeholder_screen.dart';
import 'package:ghanima/main.dart';

void _usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Splash navigates to Auth and Google shows unavailable message',
      (tester) async {
    _usePhoneScreen(tester);
    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);

    await tester.tap(find.text('تسجيل الدخول باستخدام Google'));
    await tester.pumpAndSettle();

    expect(
      find.text('تسجيل الدخول عبر Google غير متوفر حاليًا. يمكنك المتابعة كضيف.'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('Guest continues to Shell', (tester) async {
    _usePhoneScreen(tester);
    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('المتابعة كضيف'));
    await tester.pumpAndSettle();

    expect(find.byType(ShellScreen), findsOneWidget);
  });

  testWidgets('Shell renders HomeScreen initially', (tester) async {
    _usePhoneScreen(tester);
    await tester.pumpWidget(MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('المتابعة كضيف'));
    await tester.pumpAndSettle();

    expect(find.byType(ShellScreen), findsOneWidget);
    expect(find.text('تموينات غنيمة'), findsOneWidget);
  });

  testWidgets('Placeholder screen shows success message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PlaceholderScreen()));
    expect(find.text('تم تحميل التطبيق بنجاح'), findsOneWidget);
  });
}