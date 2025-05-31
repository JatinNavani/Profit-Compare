import 'package:flutter/material.dart';

class HomeTextStyles {
  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.40,
  );

  static const TextStyle label = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  static const TextStyle inputLabel = TextStyle(
    color: Color(0xFF2C2929),
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  // ✅ **NEW: Fix for inputHint**
  static const TextStyle inputHint = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle navItem = TextStyle(
    color: Color(0xFF333333),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle navItemActive = TextStyle(
    color: Color(0xFF595CE6),
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
}
