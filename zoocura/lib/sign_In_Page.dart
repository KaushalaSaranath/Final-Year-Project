// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoocura/image_picker_screen.dart';
import 'sign_up_page.dart';

/// A StatefulWidget for user login with email and password.
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers to capture user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Toggle for showing/hiding password
  bool _isPasswordVisible = false;

  // Show loading indicator during login process
  bool _isLoading = false;

  /// Attempts to log in the user using Firebase Authentication
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Check for empty input
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Please enter email and password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Firebase Auth sign-in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // On success, navigate to Image Picker screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ImagePickerScreen()),
      );
    } catch (e) {
      // Handle login failure
      _showSnackbar("Login failed. Try Again");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Display a snackbar with an error or info message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// UI build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/paw_prints.png', fit: BoxFit.cover),
          ),

          // Show progress indicator during loading
          if (_isLoading) Center(child: CircularProgressIndicator()),

          // Login form
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    SizedBox(height: 40),

                    // Email input
                    _buildTextField(emailController, 'Email'),
                    SizedBox(height: 20),

                    // Password input with visibility toggle
                    _buildPasswordField(passwordController, 'Password'),
                    SizedBox(height: 20),

                    // Sign In button
                    ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      child: Text(' Sign In ',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),

                    // Redirect to Sign Up page
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        );
                      },
                      child: Text("Don't have an account? Sign Up",
                          style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a styled text field for input (used for email)
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  /// Builds a password field with visibility toggle
  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: IconButton(
          icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
