import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/disease_result.dart';
import 'api_config.dart';

/// Disease Detection API Service
///
/// Sends crop images to the AI model for disease identification.
///
/// Expected API contract:
///   POST {baseUrl}/predict
///   Content-Type: multipart/form-data
///   Body: image file field named 'image'
///
///   Response 200:
///   {
///     "disease": "Leaf Blight",         // or "disease_name"
///     "confidence": 0.87,
///     "treatment": "Apply Mancozeb...",  // or "recommended_treatment"
///     "prevention": "Avoid overhead irrigation..."
///   }
///
/// Setup:
///   1. Your teammate deploys the model (Flask/FastAPI)
///   2. Get the endpoint URL
///   3. Paste it in api_config.dart → diseaseModelBaseUrl
class DiseaseApiService {
  /// Sends crop image to AI model and returns disease detection result.
  /// Falls back to demo result if API is not configured or fails.
  Future<DiseaseResult> detectDisease(File imageFile) async {
    if (!ApiConfig.isDiseaseModelConfigured) {
      // Demo mode — simulate API response with delay
      await Future.delayed(const Duration(seconds: 2));
      return DiseaseResult.demo();
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.diseaseModelEndpoint),
      );

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: 'crop_image.jpg',
        ),
      );

      // Add optional metadata headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Send with timeout
      final streamedResponse = await request.send().timeout(
        ApiConfig.imageUploadTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DiseaseResult.fromApiResponse(data);
      } else {
        throw Exception('Model API returned status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Return demo result on failure so the app doesn't crash
      return DiseaseResult.demo();
    }
  }

  /// Check if the model API server is reachable.
  Future<bool> healthCheck() async {
    if (!ApiConfig.isDiseaseModelConfigured) return false;

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.diseaseModelBaseUrl}/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
