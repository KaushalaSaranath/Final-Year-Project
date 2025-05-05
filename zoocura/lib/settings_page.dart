// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_In_Page.dart';

/// A simple settings screen providing the user an option to log out.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Handles user logout by signing out from FirebaseAuth
  /// and navigating to the sign-in screen, clearing all previous routes.
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Redirect to sign-in page, removing all existing routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SignInPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          // Logout button with icon
          child: ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }
}
