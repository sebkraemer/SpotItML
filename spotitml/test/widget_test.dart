import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotitml/main.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SpotItMLApp());
    await tester.pumpAndSettle();
    
    // Basic test to verify app loads
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('SpotItML'), findsOneWidget);
  });
}
