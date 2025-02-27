import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './services/api_service.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  bool _isLoading = false;
  String? _prediction;

  final ImagePicker _picker = ImagePicker();

  // Pick Image from Gallery or Camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null; // Reset previous results
      });
    }
  }

  // Upload Image & Get Prediction
  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    final result = await ApiService.uploadImage(_image!);
    
    setState(() {
      _isLoading = false;
      _prediction = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Zoocura - Skin Infection Detector")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null
              ? Icon(Icons.image, size: 100, color: Colors.grey)
              : Image.file(_image!, height: 200),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text("Gallery"),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Camera"),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text("Upload & Predict"),
                ),
          SizedBox(height: 20),
          _prediction != null
              ? Text(
                  "Prediction: $_prediction",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
