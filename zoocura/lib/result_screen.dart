// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:zoocura/models/prediction_result.dart';
import 'package:zoocura/models/infection_info.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final PredictionResult prediction;

  const ResultScreen({
    super.key,
    required this.image,
    required this.prediction,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  InfectionInfo? _infectionInfo;

  @override
  void initState() {
    super.initState();
    // Load relevant information based on the predicted skin infection
    _loadInfectionInfo(widget.prediction.predictedClass);
  }

  /// Loads infection-related data from the local JSON asset
  Future<void> _loadInfectionInfo(String predictedClass) async {
    try {
      final jsonData =
          await rootBundle.loadString('assets/infection_data.json');
      final dataMap = json.decode(jsonData);

      final infectionData = dataMap[predictedClass.toLowerCase()];

      if (infectionData != null) {
        setState(() {
          _infectionInfo = InfectionInfo.fromJson(infectionData);
        });
      } else {
        print("No info found for $predictedClass");
      }
    } catch (e) {
      print("Error loading infection info: $e");
    }
  }

  /// Uploads the image to Firebase Storage and stores the URL in Firestore
  Future<void> _uploadImageToFirebase() async {
    try {
      // Generate unique image file name
      String fileName = Uuid().v4() + '.jpg';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("user_images/$fileName");

      UploadTask uploadTask = ref.putFile(widget.image);
      await uploadTask.whenComplete(() async {
        // Get URL after upload completes
        String downloadURL = await ref.getDownloadURL();
        print("Image URL: $downloadURL");

        await _saveImageUrlToFirestore(downloadURL);
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  /// Saves the image URL and prediction result to Firestore under the user's ID
  Future<void> _saveImageUrlToFirestore(String downloadURL) async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User not signed in");
        return;
      }

      // Save under: user_images/{userId}/predictions
      CollectionReference predictions = FirebaseFirestore.instance
          .collection('user_images')
          .doc(userId)
          .collection('predictions');

      widget.prediction.imageUrl = downloadURL;

      await predictions.add(widget.prediction.toJson());

      // Navigate back after saving
      Navigator.pop(context);
      print("Image URL saved to Firestore under user $userId");
    } catch (e) {
      print("Error saving image URL to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Zoocura'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          // Faint background pattern with paw prints
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/paw_prints.png"),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title & Summary
                  Text(
                    "Here's What We Found!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                      "We've identified the issue. Let's get you the details!"),
                  SizedBox(height: 20),

                  // Display the image that was analyzed
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      widget.image,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 15),

                  // Prediction label
                  Text(
                    "Infection Detected:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.prediction.predictedClass,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Infection description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What is it?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Text(
                    _infectionInfo?.reason ?? "Loading reason...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Solution info
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What Can You Do About It?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Text(
                    _infectionInfo?.solution ?? "Loading solution...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Button to go back
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      "Back Again",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Button to save the image and data
                  ElevatedButton(
                    onPressed: () => _uploadImageToFirebase(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
