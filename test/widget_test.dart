import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yatra_flow/main.dart';
import 'package:yatra_flow/widgets/auth_background.dart';

void main() {
  testWidgets('mobile number entry validates and continues to OTP', (
    tester,
  ) async {
    await tester.pumpWidget(const YatraFlowApp());

    expect(find.byType(AuthBackground), findsOneWidget);
    expect(find.text('YatraFlow'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byKey(const Key('phone-number')), '9876543210');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();

    expect(find.text('Verify your number'), findsOneWidget);
    expect(find.byType(AuthBackground), findsNWidgets(2));
    expect(
      find.text('Enter the 6-digit code sent to\n+91 ******3210'),
      findsOneWidget,
    );
    expect(find.textContaining('123456'), findsOneWidget);
  });

  testWidgets('demo OTP accepts 123456 and rejects an incorrect code', (
    tester,
  ) async {
    await tester.pumpWidget(const YatraFlowApp());
    await tester.enterText(find.byKey(const Key('phone-number')), '9876543210');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('otp-code')), '000000');
    await tester.pump();
    await tester.tap(find.text('Verify'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    expect(
      find.text('That code didn’t match. Please try again.'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('otp-code')), '123456');
    await tester.pump();
    await tester.tap(find.text('Verify'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    expect(find.text('You’re all set!'), findsOneWidget);
  });

  testWidgets('invalid Indian number shows an error without navigating', (
    tester,
  ) async {
    await tester.pumpWidget(const YatraFlowApp());
    await tester.enterText(find.byKey(const Key('phone-number')), '1234567890');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    expect(find.text('Verify your number'), findsNothing);
  });

  testWidgets('country selection updates code and number length', (
    tester,
  ) async {
    await tester.pumpWidget(const YatraFlowApp());
    await tester.tap(find.text('+91'));
    await tester.pumpAndSettle();
    expect(find.text('Select country'), findsOneWidget);
    await tester.tap(find.text('Australia'));
    await tester.pumpAndSettle();

    expect(find.text('+61'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('phone-number')), '412345678');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });
}
