import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl =
      "http://127.0.0.1:5000"; // Replace with actual server IP

  static Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await Dio().post("$_baseUrl/predict", data: formData);

      if (response.statusCode == 200) {
        return "Infection: ${response.data['predicted_class']} \nConfidence: ${response.data['confidence']}%";
      } else {
        return "Error: ${response.statusMessage}";
      }
    } catch (e) {
      return "Failed to upload image: $e";
    }
  }
}
