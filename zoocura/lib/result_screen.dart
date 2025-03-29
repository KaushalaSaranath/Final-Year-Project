import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final String prediction;

  const ResultScreen(
      {super.key, required this.image, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text('Zoocura'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          // Background with paw prints
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/paw_prints.png"),
                fit: BoxFit.cover,
                opacity: 0.5, // Light background effect
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView( // Makes the screen scrollable
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Here's What We Found!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                        "We've identified the issue. Let's get you the details!"),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        image,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Infection Detected:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      prediction,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20),
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
                      "Scabies is a contagious skin condition caused by tiny mites that burrow under the skin, leading to intense itching and a rash, often appearing as small bumps or lines. ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
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
                      "Treatment: Scabies is treated with topical medications (creams and lotions) that kill the mites, or sometimes with oral medication.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        "Back Again",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
