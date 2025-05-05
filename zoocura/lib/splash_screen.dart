// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Splash screen that shows a Lottie animation and routes based on login status.
class SplashScreen extends StatefulWidget {
  // Flag to indicate if user is already logged in
  final bool isLoggedIn;

  const SplashScreen({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 4 seconds before navigating
    Timer(const Duration(seconds: 4), () {
      if (widget.isLoggedIn) {
        // If user is logged in, go to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // If user is not logged in, go to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome text at the top
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Welcome to Zoocura !',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Lottie animation in the center
            Expanded(
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/animation.json', // Path to your Lottie file
                  repeat: true, // Loop the animation
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
