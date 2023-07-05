class PredictionRequest {
  final double temperature;
  final double humidity;
  final double uvIndex;

  PredictionRequest({
    required this.temperature,
    required this.humidity,
    required this.uvIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'uvIndex': uvIndex,
    };
  }
}
