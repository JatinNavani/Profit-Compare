import 'package:flutter/material.dart';
import '../theme/home_text_styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _capitalController = TextEditingController(); // ✅ Fixed Controller

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3), // Light background
      body: SafeArea(
        child: Stack(
          children: [
            // Curved Background Section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: Color(0xFF595CE6), // Primary color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 40),
                  child: Text(
                    'Customize your\nInvestment Plan!',
                    style: HomeTextStyles.title,
                  ),
                ),
              ),
            ),

            // Main Form Section
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(39),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLabel('Investment Amount'),
                    _buildInputField('Enter amount (e.g., ₹50000)', _capitalController), // ✅ Pass Controller

                    SizedBox(height: 10),

                    _buildLabel('Time Horizon (Optional)'),
                    _buildInputField('1 year, 3 years, 5 years', null),

                    SizedBox(height: 10),

                    _buildLabel('Risk Tolerance (Optional)'),
                    _buildInputField('Low / Medium / High', null),

                    SizedBox(height: 20),

                    _buildCustomizeButton(context), // Pass context
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context), // ✅ Pass context
    );
  }

  // Input Field Widget
  Widget _buildInputField(String hintText, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: controller, // ✅ Assign Controller (if provided)
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: HomeTextStyles.inputHint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // Label Widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(text, style: HomeTextStyles.label),
    );
  }

  // ✅ Customize Button - Passes Investment Amount
  Widget _buildCustomizeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String capital = _capitalController.text.trim();
        if (capital.isEmpty) capital = "Default"; // ✅ Default value if empty

        Navigator.pushNamed(context, '/comparison', arguments: capital); // ✅ Navigate with Capital
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF595CE6),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text('Customize', style: HomeTextStyles.buttonText),
      ),
    );
  }

  // ✅ Bottom Navigation Bar with Profile Navigation
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 1, // Set the current active tab index
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 2) {
           Navigator.pushNamed(context, '/profile');
        } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/chat');
          } else if (index == 4) Navigator.pushNamed(context, '/asset_class');
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Customize Investments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Assets'),
      ],
    );
  }
}
