import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitcompare/screens/login_screen.dart'; // ✅ Adjust this import if needed

void main() {
  group('🧪 LoginScreen Widget Tests', () {
    
    testWidgets('Test 1: Show error on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final loginButton = find.text('Login Now');
      await tester.tap(loginButton);
      await tester.pump(); // Let Snackbar appear

      expect(find.text('Please enter both email and password.'), findsOneWidget);
    });

    testWidgets('Test 2: Invalid credentials shows error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'invalid@test.com');
      await tester.enterText(passwordField, 'wrongpass');

      final loginButton = find.text('Login Now');
      await tester.tap(loginButton);
      await tester.pump(); // Allow time for UI to update

      // ⚠️ This assumes AuthService returns null. You may need to mock AuthService for full reliability.
      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('Test 3: Input fields accept user text', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'jatin11.navani@gmail.com');
      await tester.enterText(passwordField, 'jatin123');

      expect(find.text('jatin11.navani@gmail.com'), findsOneWidget);
      expect(find.text('jatin123'), findsOneWidget);
    });

  });
}
