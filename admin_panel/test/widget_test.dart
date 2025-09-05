// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:gizmo_store_admin/main.dart';

void main() {
  testWidgets('Admin panel app smoke test', (WidgetTester tester) async {
    // Initialize Firebase for testing
    await Firebase.initializeApp();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdminPanelApp());

    // Verify that the login screen is displayed
    expect(find.text('Admin Login'), findsOneWidget);
  });
}
