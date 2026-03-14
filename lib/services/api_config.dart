/// ──────────────────────────────────────────────────────────────
/// API CONFIGURATION — All API keys and endpoints in one place
/// ──────────────────────────────────────────────────────────────
///
/// HOW TO SET UP:
/// 1. OpenWeatherMap  → https://openweathermap.org/api → Sign up → Get API key (free tier)
/// 2. Google Translate → https://console.cloud.google.com → Enable Cloud Translation API → Get key
/// 3. Disease Model   → Your teammate's deployed model URL
/// 4. Firebase         → https://console.firebase.google.com → Create project → Download config
///
class ApiConfig {
  // ─── Weather API (OpenWeatherMap) ──────────────────────────
  // Free tier: 60 calls/min, current weather + 5-day forecast
  // Sign up: https://openweathermap.org/api
  static const String openWeatherMapApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String openWeatherGeoUrl = 'https://api.openweathermap.org/geo/1.0';

  // ─── Google Translate API ─────────────────────────────────
  // Enable: Google Cloud Console → Cloud Translation API
  // Pricing: $20 per 1M characters (first 500K free/month)
  static const String googleTranslateApiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY';
  static const String googleTranslateBaseUrl = 'https://translation.googleapis.com/language/translate/v2';

  // ─── AI Disease Detection Model ───────────────────────────
  // Your teammate's deployed model endpoint
  // Expected: POST /predict with multipart image → { disease, confidence, treatment }
  static const String diseaseModelBaseUrl = 'YOUR_DISEASE_MODEL_URL';
  static const String diseaseModelEndpoint = '$diseaseModelBaseUrl/predict';

  // ─── Firebase Configuration ───────────────────────────────
  // Add google-services.json (Android) & GoogleService-Info.plist (iOS)
  // to android/app/ and ios/Runner/ respectively
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';

  // ─── API Timeouts ─────────────────────────────────────────
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration imageUploadTimeout = Duration(seconds: 30);

  // ─── Validation ───────────────────────────────────────────
  static bool get isWeatherConfigured =>
      openWeatherMapApiKey != 'YOUR_OPENWEATHERMAP_API_KEY' &&
      openWeatherMapApiKey.isNotEmpty;

  static bool get isTranslateConfigured =>
      googleTranslateApiKey != 'YOUR_GOOGLE_TRANSLATE_API_KEY' &&
      googleTranslateApiKey.isNotEmpty;

  static bool get isDiseaseModelConfigured =>
      diseaseModelBaseUrl != 'YOUR_DISEASE_MODEL_URL' &&
      diseaseModelBaseUrl.isNotEmpty;

  // ─── Language Code Mapping ────────────────────────────────
  // App locale codes → Google Translate API language codes
  static const Map<String, String> translateLanguageCodes = {
    'en': 'en',
    'hi': 'hi',
    'pa': 'pa',
    'mr': 'mr',
    'gu': 'gu',
    'ta': 'ta',
    'te': 'te',
  };
}
