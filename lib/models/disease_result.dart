class DiseaseResult {
  final String diseaseName;
  final double confidence;
  final String treatment;
  final String prevention;
  final bool isHealthy;

  DiseaseResult({
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
    this.prevention = '',
    this.isHealthy = false,
  });

  factory DiseaseResult.fromApiResponse(Map<String, dynamic> json) {
    return DiseaseResult(
      diseaseName: json['disease'] ?? json['disease_name'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      treatment: json['treatment'] ?? json['recommended_treatment'] ?? 'Consult an expert',
      prevention: json['prevention'] ?? '',
      isHealthy: (json['confidence'] ?? 0).toDouble() < 0.1,
    );
  }

  factory DiseaseResult.healthy() {
    return DiseaseResult(
      diseaseName: 'No Disease',
      confidence: 0.98,
      treatment: 'No treatment needed — your crop is healthy!',
      prevention: 'Continue regular care and monitoring.',
      isHealthy: true,
    );
  }

  factory DiseaseResult.demo() {
    return DiseaseResult(
      diseaseName: 'Leaf Blight',
      confidence: 0.87,
      treatment: 'Apply Mancozeb fungicide at 2.5g/L water. Spray every 10 days.',
      prevention: 'Avoid overhead irrigation. Ensure proper spacing between plants.',
    );
  }

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';

  Map<String, dynamic> toMap() {
    return {
      'diseaseName': diseaseName,
      'confidence': confidence,
      'treatment': treatment,
      'prevention': prevention,
      'isHealthy': isHealthy,
      'detectedAt': DateTime.now().toIso8601String(),
    };
  }
}
