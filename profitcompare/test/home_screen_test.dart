import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitcompare/screens/home_screen.dart'; // Adjust if path is different

void main() {
  group('🧪 HomeScreen Widget Tests', () {
    testWidgets('Test 1: All key UI elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('Customize your\nInvestment Plan!'), findsOneWidget);
      expect(find.text('Investment Amount'), findsOneWidget);
      expect(find.text('Time Horizon (Optional)'), findsOneWidget);
      expect(find.text('Risk Tolerance (Optional)'), findsOneWidget);
      expect(find.text('Customize'), findsOneWidget);
    });

    testWidgets('Test 2: Enter investment amount and tap Customize', (WidgetTester tester) async {
      String? capturedArgument;

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/comparison') {
              capturedArgument = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (_) => Scaffold(body: Text('Comparison for ₹${capturedArgument ?? ""}')),
              );
            }
            return null;
          },
        ),
      );

      await tester.enterText(find.byType(TextField).first, '75000');
      await tester.tap(find.text('Customize'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Comparison for ₹75000'), findsOneWidget);
    });

    testWidgets('Test 3: Tapping BottomNavigationBar navigates to Profile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/profile') {
              return MaterialPageRoute(
                builder: (_) => Scaffold(body: Text('Profile Screen')),
              );
            }
            return null;
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      expect(find.text('Profile Screen'), findsOneWidget);
    });
  });
}
