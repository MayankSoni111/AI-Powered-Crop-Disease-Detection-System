import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech Service — Voice Over for Farmers
///
/// Reads out disease results, weather alerts, and guidance in the farmer's
/// selected language. Essential for farmers who may have limited literacy.
///
/// Supports all 7 app languages via device TTS engines:
///   en (English), hi (Hindi), pa (Punjabi), mr (Marathi),
///   gu (Gujarati), ta (Tamil), te (Telugu)
///
/// Usage:
///   final tts = TtsService();
///   await tts.initialize('hi');
///   await tts.speak('आपकी फसल में पत्ती झुलसा रोग पाया गया');
///   tts.stop();
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String _currentLanguage = 'en';

  bool get isSpeaking => _isSpeaking;
  String get currentLanguage => _currentLanguage;

  // Maps app locale codes to TTS locale codes (BCP 47)
  static const Map<String, String> _ttsLanguageCodes = {
    'en': 'en-IN',   // English (India accent)
    'hi': 'hi-IN',   // Hindi
    'pa': 'pa-IN',   // Punjabi
    'mr': 'mr-IN',   // Marathi
    'gu': 'gu-IN',   // Gujarati
    'ta': 'ta-IN',   // Tamil
    'te': 'te-IN',   // Telugu
  };

  /// Initialize TTS with the given language.
  Future<void> initialize(String languageCode) async {
    _currentLanguage = languageCode;

    // Set language
    final ttsLocale = _ttsLanguageCodes[languageCode] ?? 'en-IN';
    await _tts.setLanguage(ttsLocale);

    // Configure voice settings for clarity
    await _tts.setSpeechRate(0.45);   // Slow speed for farmers
    await _tts.setVolume(1.0);        // Full volume
    await _tts.setPitch(1.0);         // Normal pitch

    // Set up callbacks
    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  /// Speak the given text. Stops any currently playing speech first.
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize(_currentLanguage);
    }

    if (_isSpeaking) {
      await stop();
    }

    if (text.isNotEmpty) {
      _isSpeaking = true;
      await _tts.speak(text);
    }
  }

  /// Stop any currently playing speech.
  Future<void> stop() async {
    _isSpeaking = false;
    await _tts.stop();
  }

  /// Pause speech (Android only).
  Future<void> pause() async {
    await _tts.pause();
  }

  /// Change language on the fly (e.g., when user switches language).
  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    final ttsLocale = _ttsLanguageCodes[languageCode] ?? 'en-IN';
    await _tts.setLanguage(ttsLocale);
  }

  /// Set speech rate (0.0 to 1.0). Default: 0.45 (slow for farmers).
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Check if a language is available on the device.
  Future<bool> isLanguageAvailable(String languageCode) async {
    final ttsLocale = _ttsLanguageCodes[languageCode] ?? 'en-IN';
    final result = await _tts.isLanguageAvailable(ttsLocale);
    return result == 1;
  }

  /// Get list of available TTS languages on this device.
  Future<List<String>> getAvailableLanguages() async {
    final languages = await _tts.getLanguages;
    return List<String>.from(languages ?? []);
  }

  /// Dispose of TTS resources.
  void dispose() {
    _tts.stop();
  }
}
