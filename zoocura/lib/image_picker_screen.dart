import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Zoocura - Skin Infection Detector'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          /// The Staggered Grid should be scrollable
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(6, (index) {
                    final assetImages = [
                      'assets/1.jpg',
                      'assets/2.jpg',
                      'assets/3.jpg',
                      'assets/4.jpg',
                      'assets/5.jpg',
                      'assets/6.jpg',
                    ];
                    return StaggeredGridTile.fit(
                      crossAxisCellCount: index % 3 == 0 ? 2 : 1,
                      child: GestureDetector(
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
                              assetImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          /// Bottom Buttons (Fixed, Not Scrollable)
          Padding(
            padding: EdgeInsets.all(10),
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
        builder: (context) =>
            ResultScreen(image: widget.image, prediction: _prediction!),
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
