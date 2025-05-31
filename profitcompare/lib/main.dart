import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/comparison_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/report_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/asset_allocation_screen.dart';
import 'screens/gpt_chat_screen.dart';
import 'screens/asset_class_screen.dart';
import 'screens/fixed_income_screen.dart';
import 'screens/equity_screen.dart';
import 'screens/alternate_investments_screen.dart';
import 'screens/allocation_summary_screen.dart'; // ✅ NEW

// Local Database
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper.database;
  runApp(ProfitCompareApp());
}

class ProfitCompareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProfitCompare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/comparison': (context) => ComparisonScreen(),
        '/profile': (context) => ProfileScreen(),
        '/report': (context) => ReportScreen(),
        '/explore': (context) => ExploreScreen(),
        '/chat': (context) => GPTChatScreen(),
        '/asset_class': (context) => AssetClassScreen(),
        '/fixed': (context) => FixedIncomeScreen(),
        '/equity': (context) => EquityScreen(),
        '/alternate': (context) => AlternateInvestmentsScreen(),
        '/allocation_summary': (context) => AllocationSummaryScreen(), // ✅ Added
        '/allocation': (context) {
          final risk = ModalRoute.of(context)!.settings.arguments as String;
          return AssetAllocationScreen(riskTolerance: risk);
        },
      },
    );
  }
}
