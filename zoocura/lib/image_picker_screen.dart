// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

// Import packages and dependencies
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoocura/loading_screen.dart';
import 'package:zoocura/models/prediction_result.dart';
import 'package:zoocura/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This screen allows users to pick an image (from gallery or camera),
// sends it for prediction, and displays past predictions.
class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image; // Holds the selected image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  List<PredictionResult> _predictions = []; // List of previous predictions
  bool _isLoading = true; // Flag to show loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _loadPredictions(); // Fetch previous predictions when the screen loads
  }

  // Loads prediction history from Firestore for the logged-in user
  Future<void> _loadPredictions() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      // If user is not signed in, do nothing
      if (userId == null) {
        print("User not signed in");
        setState(() => _isLoading = false);
        return;
      }

      // Access the Firestore collection: user_images/{userId}/predictions
      CollectionReference predictionsRef = FirebaseFirestore.instance
          .collection('user_images')
          .doc(userId)
          .collection('predictions');

      // Retrieve prediction documents
      QuerySnapshot snapshot = await predictionsRef.get();

      // Convert documents into PredictionResult objects
      List<PredictionResult> results = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PredictionResult.fromJson(data);
      }).toList();

      // Update state with fetched predictions
      setState(() {
        _predictions = results;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching predictions: $e");
      setState(() => _isLoading = false);
    }
  }

  // Opens image picker (camera or gallery) and navigates to loading screen
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _navigateToLoadingScreen(); // Send image for prediction
    }
  }

  // Navigates to the loading screen to start prediction process
  void _navigateToLoadingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen(image: _image!)),
    ).then((_) => _loadPredictions()); // Refresh prediction history on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and settings icon
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Zoocura - Skin Infection Detector'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// Section: Display Prediction History
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading spinner
                : _predictions.isEmpty
                    ? Center(child: Text("No prediction history found."))
                    : ListView.builder(
                        itemCount: _predictions.length,
                        itemBuilder: (context, index) {
                          final prediction = _predictions[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: ListTile(
                              leading: Image.network(
                                prediction.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              ),
                              title: Text(prediction.predictedClass),
                              subtitle: Text(
                                  'Confidence: ${prediction.confidence.toStringAsFixed(2)}%'),
                            ),
                          );
                        },
                      ),
          ),

          /// Section: Image Picker Buttons
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button to select image from gallery
                IconButton(
                  icon: Icon(Icons.photo_library, size: 40),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                SizedBox(width: 30),
                // Button to capture image using camera
                IconButton(
                  icon: Icon(Icons.camera_alt, size: 40),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
