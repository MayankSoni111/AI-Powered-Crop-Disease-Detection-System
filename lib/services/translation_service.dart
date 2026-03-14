import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Translation API Service — Google Cloud Translation API
///
/// Translates dynamic content (disease names, treatments, weather descriptions)
/// that isn't covered by the static UI translation files.
///
/// API: Google Cloud Translation API v2
/// Docs: https://cloud.google.com/translate/docs/reference/rest/v2/translations
///
/// Usage:
///   final service = TranslationService();
///   final hindi = await service.translate('Leaf Blight detected', 'hi');
///   final batch = await service.translateBatch(['treatment', 'prevention'], 'ta');
class TranslationService {
  final Map<String, Map<String, String>> _cache = {};

  /// Translate a single text string to the target language.
  ///
  /// [text] — Text to translate (in English)
  /// [targetLang] — Target language code (hi, pa, mr, gu, ta, te)
  /// Returns translated text, or original text if API is not configured / fails.
  Future<String> translate(String text, String targetLang) async {
    if (targetLang == 'en') return text;

    // Check cache first
    final cacheKey = '${targetLang}_$text';
    if (_cache.containsKey(targetLang) && _cache[targetLang]!.containsKey(text)) {
      return _cache[targetLang]![text]!;
    }

    if (!ApiConfig.isTranslateConfigured) {
      return text; // Return original if API not configured
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.googleTranslateBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'target': ApiConfig.translateLanguageCodes[targetLang] ?? targetLang,
          'source': 'en',
          'key': ApiConfig.googleTranslateApiKey,
          'format': 'text',
        }),
      ).timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translated = data['data']['translations'][0]['translatedText'] as String;

        // Cache the result
        _cache.putIfAbsent(targetLang, () => {});
        _cache[targetLang]![text] = translated;

        return translated;
      }
      return text;
    } catch (e) {
      return text;
    }
  }

  /// Translate multiple texts at once (batch translation).
  ///
  /// More efficient than calling translate() multiple times.
  /// Returns a map of original text → translated text.
  Future<Map<String, String>> translateBatch(
    List<String> texts,
    String targetLang,
  ) async {
    if (targetLang == 'en') {
      return {for (var t in texts) t: t};
    }

    if (!ApiConfig.isTranslateConfigured) {
      return {for (var t in texts) t: t};
    }

    // Separate cached and uncached texts
    final results = <String, String>{};
    final uncached = <String>[];

    for (var text in texts) {
      if (_cache.containsKey(targetLang) && _cache[targetLang]!.containsKey(text)) {
        results[text] = _cache[targetLang]![text]!;
      } else {
        uncached.add(text);
      }
    }

    if (uncached.isEmpty) return results;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.googleTranslateBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': uncached,
          'target': ApiConfig.translateLanguageCodes[targetLang] ?? targetLang,
          'source': 'en',
          'key': ApiConfig.googleTranslateApiKey,
          'format': 'text',
        }),
      ).timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translations = data['data']['translations'] as List;

        for (int i = 0; i < uncached.length && i < translations.length; i++) {
          final translated = translations[i]['translatedText'] as String;
          results[uncached[i]] = translated;

          // Cache
          _cache.putIfAbsent(targetLang, () => {});
          _cache[targetLang]![uncached[i]] = translated;
        }
      } else {
        // Fallback: return original texts
        for (var text in uncached) {
          results[text] = text;
        }
      }
    } catch (e) {
      for (var text in uncached) {
        results[text] = text;
      }
    }

    return results;
  }

  /// Translate disease scan results (disease name + treatment) to user's language.
  Future<Map<String, String>> translateDiseaseResult({
    required String diseaseName,
    required String treatment,
    required String prevention,
    required String targetLang,
  }) async {
    if (targetLang == 'en') {
      return {
        'diseaseName': diseaseName,
        'treatment': treatment,
        'prevention': prevention,
      };
    }

    final results = await translateBatch(
      [diseaseName, treatment, prevention],
      targetLang,
    );

    return {
      'diseaseName': results[diseaseName] ?? diseaseName,
      'treatment': results[treatment] ?? treatment,
      'prevention': results[prevention] ?? prevention,
    };
  }

  /// Clear translation cache.
  void clearCache() {
    _cache.clear();
  }
}
