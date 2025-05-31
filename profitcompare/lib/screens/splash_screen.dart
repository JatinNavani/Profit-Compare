import 'package:flutter/material.dart';
import '../theme/splash_text_styles.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ✅ Curved Background with Logo
            Container(
              width: screenWidth,
              height: screenHeight * 0.4, // Adjusted height
              decoration: BoxDecoration(
                color: Color(0xFF6662F0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Increased Logo Size
                  SizedBox(
                    width: screenWidth * 0.8, // Adjust width
                    height: screenHeight * 0.4, // Adjust height
                    child: Image.network(
                      "https://s3.ap-south-1.amazonaws.com/www.jatinnavani.in/MC_app/ProfitCompare_splash_logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50), // ✅ Spacing between logo & buttons

            // ✅ Authentication Buttons
            _buildAuthButton(
              icon: Icons.apple,
              text: "Sign in with Apple",
              style: SplashTextStyles.signInApple,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              onTap: () {},
            ),
            SizedBox(height: 12),

            _buildAuthButton(
              icon: Icons.g_translate,
              text: "Sign in with Google",
              style: SplashTextStyles.signInGoogle,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              onTap: () {},
            ),
            SizedBox(height: 12),

            _buildAuthButton(
              text: "Get started",
              style: SplashTextStyles.getStarted,
              backgroundColor: Color(0xFF595CE6),
              borderColor: Color(0xFF595CE6),
              onTap: () {
                Navigator.pushNamed(context, "/register");
              },
            ),
            SizedBox(height: 12),

            _buildAuthButton(
              text: "Login",
              style: SplashTextStyles.login,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
            ),

            SizedBox(height: 25), // ✅ Bottom spacing

            // ✅ New User? Sign In Link
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'New around here? ', style: SplashTextStyles.newUser),
                  TextSpan(
                    text: 'Sign in',
                    style: SplashTextStyles.signInLink,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Button Builder Function
  Widget _buildAuthButton({
    IconData? icon,
    required String text,
    required TextStyle style,
    required Color backgroundColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320, // ✅ Fixed width for consistency
        height: 58,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: style.color),
              SizedBox(width: 10),
            ],
            Text(text, style: style),
          ],
        ),
      ),
    );
  }
}
