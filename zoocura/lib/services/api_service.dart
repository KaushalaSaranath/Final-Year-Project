import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // Import this for MediaType

class ApiService {
  static const String _baseUrl = "http://172.27.42.180:3000"; // Replace with actual server IP

  static Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      String? mimeType = lookupMimeType(imageFile.path);

      var request = http.MultipartRequest("POST", Uri.parse("$_baseUrl/predict"));
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
        return "Infection: ${jsonResponse['predicted_class']} \nConfidence: ${jsonResponse['confidence']}%";
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Failed to upload image: $e";
    }
  }
}
