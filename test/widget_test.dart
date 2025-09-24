// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swaad/screens/welcome_screen.dart';

void main() {
  testWidgets('Welcome screen loads correctly', (WidgetTester tester) async {
    // Build the welcome screen and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    // Verify that the welcome screen loads
    expect(find.byType(WelcomeScreen), findsOneWidget);

    // Look for some text that should be on the welcome screen
    expect(find.text('Swaad'), findsAtLeast(1));
  });

  testWidgets('App has a Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
