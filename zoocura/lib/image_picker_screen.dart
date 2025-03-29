import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoocura/result_screen.dart';
import './services/api_service.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _navigateToLoadingScreen();
    }
  }

  void _navigateToLoadingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen(image: _image!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zoocura - Skin Infection Detector")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                // List of asset images to show in the grid
                final assetImages = [
                  'assets/1.jpg',
                  'assets/2.jpg',
                  'assets/3.jpg',
                  'assets/4.jpg',
                  'assets/5.jpg',
                  'assets/6.jpg',
                ];

                return GestureDetector(
                  onTap: () {
                    // Placeholder for future functionality
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        assetImages[index],  // Use image from the asset list
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.photo_library, size: 40),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                SizedBox(width: 30),
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

class LoadingScreen extends StatefulWidget {
  final File image;
  const LoadingScreen({super.key, required this.image});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String? _prediction;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    final result = await ApiService.uploadImage(widget.image);
    
    setState(() => _prediction = result);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(image: widget.image, prediction: _prediction!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
