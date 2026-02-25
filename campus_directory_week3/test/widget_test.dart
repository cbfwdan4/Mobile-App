import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_directory_week3/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Build the real app
    await tester.pumpWidget(const CampusDirectoryApp());

    // Verify HomeScreen UI
    expect(find.text('VVU Campus Directory'), findsOneWidget);
    expect(find.text('View Departments'), findsOneWidget);
    expect(find.text('Faculty Directory'), findsOneWidget);
  });
}
