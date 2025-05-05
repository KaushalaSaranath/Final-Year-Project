class PredictionResult {
  String predictedClass;
  double confidence;
  String imageUrl;

  PredictionResult({
    required this.predictedClass,
    required this.confidence,
    required this.imageUrl,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json['predicted_class'] ?? 'Unknown',
      confidence: double.tryParse(json['confidence'].toString()) ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predicted_class': predictedClass,
      'confidence': confidence,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Infection: $predictedClass\nConfidence: ${confidence.toStringAsFixed(2)}%\nImage URL: $imageUrl';
  }
}
