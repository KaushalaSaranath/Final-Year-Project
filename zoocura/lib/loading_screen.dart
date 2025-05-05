// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

// Importing Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoocura/models/prediction_result.dart';
import 'package:zoocura/result_screen.dart';
import 'package:zoocura/services/api_service.dart';

// This screen shows a loading indicator while an image is being processed.
// Once the prediction is complete, it navigates to the ResultScreen.
class LoadingScreen extends StatefulWidget {
  final File image; // The image file to be processed

  const LoadingScreen({super.key, required this.image});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  PredictionResult? _prediction; // Holds the prediction result once fetched

  @override
  void initState() {
    super.initState();
    _processImage(); // Start image processing as soon as the screen loads
  }

  // Handles image upload and receives prediction from the backend
  Future<void> _processImage() async {
    final result = await ApiService.uploadImage(widget.image); // Send image to API
    setState(() => _prediction = result); // Update prediction result

    // After prediction is received, navigate to the result display screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          image: widget.image,
          prediction: _prediction!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading spinner while the image is being processed
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}