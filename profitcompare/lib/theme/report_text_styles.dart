import 'package:flutter/material.dart';

class ReportTextStyles {
  // Title at the top (e.g., "Detailed Report!")
  static const TextStyle detailedReport = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.40,
  );

  // Section headers (e.g., "Category", "Socially Conscious")
  static const TextStyle sectionTitle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  // Large numbers (e.g., "7K", "5%", "40%")
  static const TextStyle largeHighlight = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  // Funding label text (e.g., "Funding")
  static const TextStyle fundingLabel = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  // Category title (e.g., "1-Year Return", "Volatility", "Max Drawdown")
  static const TextStyle categoryTitle = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  // Return values (e.g., "5%", "-10%", "8.0")
  static const TextStyle returnValue = TextStyle(
    color: Color(0xFF222220),
    fontSize: 26,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    height: 1.18,
  );

  // Bottom Navigation Bar (Selected Tab)
  static const TextStyle bottomNavSelected = TextStyle(
    color: Color(0xFF595CE6),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  // Bottom Navigation Bar (Unselected Tabs)
  static const TextStyle bottomNavUnselected = TextStyle(
    color: Color(0xFF333333),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  // Dropdown Text (e.g., "Gold", "Mutual Funds", "Nifty 50")
  static const TextStyle dropdownText = TextStyle(
    color: Color(0xFF2C2929),
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  // Metric Label (e.g., "Sharpe Ratio", "Risk-Reward Ratio")
  static const TextStyle metricLabel = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  // Metric Value (e.g., "1.5", "8.0", "Low")
  static const TextStyle metricValue = TextStyle(
    color: Color(0xFF222220),
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
  );

  // Investment Dropdown (Main Dropdown Display)
  static const TextStyle investmentDropdown = TextStyle(
    color: Color(0xFF2C2929),
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );
}
