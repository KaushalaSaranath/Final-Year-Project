// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:zoocura/result_screen.dart';
// import './services/api_service.dart';

// class ImagePickerScreen extends StatefulWidget {
//   const ImagePickerScreen({super.key});

//   @override
//   _ImagePickerScreenState createState() => _ImagePickerScreenState();
// }

// class _ImagePickerScreenState extends State<ImagePickerScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() => _image = File(pickedFile.path));
//       _navigateToLoadingScreen();
//     }
//   }

//   void _navigateToLoadingScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LoadingScreen(image: _image!)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Zoocura - Skin Infection Detector'),
//         backgroundColor: Colors.purple,
//       ),
//       body: Column(
//         children: [
//           /// The Staggered Grid should be scrollable
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: SingleChildScrollView(
//                 child: StaggeredGrid.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   children: List.generate(6, (index) {
//                     final assetImages = [
//                       'assets/1.jpg',
//                       'assets/2.jpg',
//                       'assets/3.jpg',
//                       'assets/4.jpg',
//                       'assets/5.jpg',
//                       'assets/6.jpg',
//                     ];
//                     return StaggeredGridTile.fit(
//                       crossAxisCellCount: index % 3 == 0 ? 2 : 1,
//                       child: GestureDetector(
//                         onTap: () {
//                           // Placeholder for future functionality
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               assetImages[index],
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),

//           /// Bottom Buttons (Fixed, Not Scrollable)
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.photo_library, size: 40),
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                 ),
//                 SizedBox(width: 30),
//                 IconButton(
//                   icon: Icon(Icons.camera_alt, size: 40),
//                   onPressed: () => _pickImage(ImageSource.camera),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LoadingScreen extends StatefulWidget {
//   final File image;
//   const LoadingScreen({super.key, required this.image});

//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   String? _prediction;

//   @override
//   void initState() {
//     super.initState();
//     _processImage();
//   }

//   Future<void> _processImage() async {
//     final result = await ApiService.uploadImage(widget.image);

//     setState(() => _prediction = result);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ResultScreen(image: widget.image, prediction: _prediction!),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';  // Add Firebase Storage
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';  // Firebase Core for initialization


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
      _uploadImageToFirebase();  // Upload image to Firebase
    }
  }

  // Upload image to Firebase Storage and save URL to Firestore
  Future<void> _uploadImageToFirebase() async {
    if (_image == null) return;

    try {
      // Generate a unique file name using UUID
      String fileName = Uuid().v4() + '.jpg';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("user_images/$fileName");

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(_image!);

      // Wait for upload to complete and get the download URL
      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        print("Image URL: $downloadURL");

        // Store the download URL in Firestore
        await _saveImageUrlToFirestore(downloadURL);

        // Navigate to the next screen
        _navigateToLoadingScreen(downloadURL);
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Save the download URL to Firestore
  Future<void> _saveImageUrlToFirestore(String downloadURL) async {
    try {
      // Add the URL to Firestore
      CollectionReference images = FirebaseFirestore.instance.collection('user_images');
      await images.add({
        'image_url': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Image URL saved to Firestore");
    } catch (e) {
      print("Error saving image URL to Firestore: $e");
    }
  }

  // Navigate to the next screen
  void _navigateToLoadingScreen(String downloadURL) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(imageUrl: downloadURL),
      ),
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
          /// Display Images from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_images')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var images = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    var imageUrl = images[index]['image_url'];
                    return Card(
                      child: Image.network(imageUrl),
                    );
                  },
                );
              },
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

class LoadingScreen extends StatelessWidget {
  final String imageUrl;
  const LoadingScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl), // Display uploaded image
            CircularProgressIndicator(),
            Text("Uploading..."),
          ],
        ),
      ),
    );
  }
}