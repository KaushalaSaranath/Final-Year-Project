// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

// Flutter and Firebase imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Internal imports - screens used in the app
import 'package:zoocura/image_picker_screen.dart';
import 'package:zoocura/sign_In_Page.dart';
import 'package:zoocura/splash_screen.dart';

// Entry point of the Flutter app
void main() async {
  // Ensures that widget binding is initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase services before app starts
  await Firebase.initializeApp();

  // Launch the app
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  final bool isLoggedIn = false; // Currently not used dynamically

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoocura',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      initialRoute: '/', // Entry route for navigation
      routes: {
        '/': (context) => SplashScreen(isLoggedIn: isLoggedIn), // First screen user sees
        '/login': (context) => SignInPage(), // Login screen route
        '/home': (context) => ImagePickerScreen(), // Main home screen with prediction features
      },
    );
  }
}

// Widget that determines whether to show login or main screen based on authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Rebuilds UI on auth state change
      builder: (context, snapshot) {
        // Show loading spinner while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in, show the home screen
        if (snapshot.hasData && snapshot.data != null) {
          return const ImagePickerScreen();
        }

        // If user is not logged in, show the login screen
        return SignInPage();
      },
    );
  }
}
