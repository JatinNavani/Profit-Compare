import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:profitcompare/main.dart' as app; // Replace with your actual main.dart import

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Screen UI Tests', () {
    testWidgets('Test 1: Empty fields shows error', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final loginButton = find.text('Login Now');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Please enter both email and password.'), findsOneWidget);
    });

    testWidgets('Test 2: Invalid credentials shows error', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'wrong@email.com');
      await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');

      final loginButton = find.text('Login Now');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('Test 3: Successful login navigates to home', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'jatin11.navani@gmail.com');
      await tester.enterText(find.byType(TextField).at(1), 'jatin123');

      final loginButton = find.text('Login Now');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome'), findsOneWidget); // Adjust according to your home screen
    });
  });
}
