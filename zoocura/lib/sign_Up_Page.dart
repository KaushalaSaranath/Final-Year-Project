// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoocura/image_picker_screen.dart';

/// A screen that allows users to register with email, password, and username.
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for handling user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final usernameController = TextEditingController();

  // Toggle to show/hide passwords
  bool _isPasswordVisible = false;

  // Loading state for async operations
  bool _isLoading = false;

  /// Registers a user using Firebase Authentication
  Future<void> registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmController.text;

    // Validate input fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("All fields are required.");
      return;
    }

    // Confirm passwords match
    if (password != confirmPassword) {
      _showSnackbar("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user using Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the main screen upon successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ImagePickerScreen()),
      );
    } catch (e) {
      // Show error message on failure
      _showSnackbar("Signup failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Displays a snackbar with a message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Main widget build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background paw print image
          Positioned.fill(
            child: Image.asset('assets/paw_prints.png', fit: BoxFit.cover),
          ),

          // Loading indicator
          if (_isLoading)
            Center(child: CircularProgressIndicator()),

          // Sign-up form
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Sign Up',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: 40),

                    // Email input
                    _buildTextField(emailController, 'Email'),
                    SizedBox(height: 20),

                    // Username input (optional for now)
                    _buildTextField(usernameController, 'Username'),
                    SizedBox(height: 20),

                    // Password input
                    _buildPasswordField(passwordController, 'Password'),
                    SizedBox(height: 20),

                    // Confirm password input
                    _buildPasswordField(confirmController, 'Confirm Password'),
                    SizedBox(height: 20),

                    // Sign up button
                    ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      child: Text('Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),

                    // Navigation back to sign in
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Already have an account? Sign In',
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

  /// Builds a styled text input field (used for email/username)
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

  /// Builds a password field with toggleable visibility
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
          icon: Icon(_isPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off),
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
