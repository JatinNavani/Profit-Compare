import 'package:flutter/material.dart';
import '../service/auth_service.dart'; // Import AuthService
import '../theme/login_text_styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  // Function to handle login
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both email and password.'),
      ));
      return;
    }

    try {
      // Call the login method from AuthService
      final user = await _authService.loginUserWithEmailAndPassword(email, password);
      
      if (user != null) {
        // If login is successful, navigate to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed. Please try again.'),
        ));
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF595CE6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.9,
                  constraints: BoxConstraints(
                    maxWidth: 400,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Login', style: LoginTextStyles.loginTitle),
                      ),
                      SizedBox(height: 10),
                      Image.network(
                        "https://s3.ap-south-1.amazonaws.com/www.jatinnavani.in/MC_app/ProfitCompare_login_logo.jpg",
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 50, color: Colors.red);
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Insert your Login Details', style: LoginTextStyles.insertDetails),
                      SizedBox(height: 15),
                      _buildInputField('Enter Your Email', controller: _emailController),
                      SizedBox(height: 12),
                      _buildInputField('Enter Your Password', controller: _passwordController, isPassword: true),
                      SizedBox(height: 25),
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField(String hintText, {bool isPassword = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: LoginTextStyles.inputLabel,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Color(0xFFCFCFCF), width: 1),
          ),
        ),
      ),
    );
  }

  // Login Button with Firebase login functionality
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _login,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFF595CE6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text('Login Now', style: LoginTextStyles.loginButton),
      ),
    );
  }
}
