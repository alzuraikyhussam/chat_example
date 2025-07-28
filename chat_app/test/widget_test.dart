// This is a basic example of a Flutter integration test.
//
// Since a functional test is being performed on the app, it should
// be placed in the integration_test directory.
//
// For instructions on how to run these tests, see the documentation:
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/main.dart';

void main() {
  testWidgets('ChatApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChatApp());

    // Verify that our splash screen shows.
    expect(find.text('ChatApp'), findsOneWidget);
    expect(find.text('Connect • Chat • Share'), findsOneWidget);

    // Wait for splash screen animation
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Should navigate to login screen since not logged in
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
