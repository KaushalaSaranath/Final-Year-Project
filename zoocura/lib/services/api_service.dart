// Name : K.M.T.Kaushala Saranath
// Student Number : w1870583 | 20200556
// Module : (2024) 6COSC023C.Y
// Project : Zoocura - Skin Infection Detector

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:zoocura/models/prediction_result.dart'; // Import MediaType

class ApiService {
  static const String _baseUrl = "http://192.168.8.105:3000"; //server IP

  static Future<PredictionResult?> uploadImage(File imageFile) async {
  try {
    String fileName = basename(imageFile.path);
    String? mimeType = lookupMimeType(imageFile.path);

    var request =
        http.MultipartRequest("POST", Uri.parse("$_baseUrl/predict"));
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      filename: fileName,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    ));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseBody);
      return PredictionResult.fromJson(jsonResponse);
    } else {
      print("Error: ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    print("Failed to upload image: $e");
    return null;
  }
}
}


