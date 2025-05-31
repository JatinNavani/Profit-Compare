import 'package:flutter/material.dart';
import '../service/auth_service.dart'; // Import AuthService
import '../theme/register_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  // Register function
  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Check if all fields are filled
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields.'),
      ));
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match.'),
      ));
      return;
    }

    try {
      // Call the createUser method from AuthService
      final user = await _authService.createUserWithEmailAndPassword(email, password);
      
      if (user != null) {
        // If registration is successful, navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message if registration fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed. Please try again.'),
        ));
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF595CE6), // Background color
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.9, // Adjust width dynamically
                  constraints: BoxConstraints(
                    maxWidth: 400, // Prevents the container from stretching too much
                  ),
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
                      Text('Register', style: RegisterTextStyles.title),
                      SizedBox(height: 10),
                      Text('Register as a New User', style: RegisterTextStyles.newUserRegister),
                      SizedBox(height: 20),

                      // Input Fields
                      _buildInputField('Enter your name', controller: _nameController),
                      _buildInputField('Enter your email', controller: _emailController),
                      _buildInputField('Enter your Phone Number', controller: _phoneController),
                      _buildInputField('Password', controller: _passwordController, isPassword: true),
                      _buildInputField('Confirm password', controller: _confirmPasswordController, isPassword: true),
                      SizedBox(height: 10),

                      // Terms & Conditions
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'I accept terms and conditions for this app.\n',
                              style: RegisterTextStyles.termsText,
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: RegisterTextStyles.termsLink,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      // Proceed Button with Firebase Registration functionality
                      GestureDetector(
                        onTap: _register,  // Call _register function when button is pressed
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF595CE6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text('Proceed', style: RegisterTextStyles.proceedButton),
                        ),
                      ),
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
        obscureText: isPassword, // Hide text if it's a password field
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: RegisterTextStyles.registerInput,
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
}
