import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Speech-to-Text Service — Voice Input for Farmers
///
/// Allows farmers to speak crop names, notes, and commands
/// instead of typing. Supports Indian languages.
///
/// Usage:
///   final sttService = SttService();
///   await sttService.initialize();
///   sttService.startListening('hi', onResult: (text) => print(text));
///   sttService.stopListening();
class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isInitialized;

  // Maps app locale codes to speech recognition locale codes
  static const Map<String, String> _sttLanguageCodes = {
    'en': 'en_IN',
    'hi': 'hi_IN',
    'pa': 'pa_IN',
    'mr': 'mr_IN',
    'gu': 'gu_IN',
    'ta': 'ta_IN',
    'te': 'te_IN',
  };

  /// Initialize the speech recognizer.
  Future<bool> initialize() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        _isListening = status == 'listening';
      },
      onError: (error) {
        _isListening = false;
      },
    );
    return _isInitialized;
  }

  /// Start listening for speech input.
  ///
  /// [languageCode] — App language code (en, hi, pa, etc.)
  /// [onResult] — Callback with recognized text (called multiple times as speech is recognized)
  /// [onFinalResult] — Callback with final recognized text
  Future<void> startListening({
    required String languageCode,
    required Function(String text) onResult,
    Function(String text)? onFinalResult,
  }) async {
    if (!_isInitialized) {
      final available = await initialize();
      if (!available) return;
    }

    final localeId = _sttLanguageCodes[languageCode] ?? 'en_IN';
    _isListening = true;

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        if (result.finalResult && onFinalResult != null) {
          onFinalResult(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      cancelOnError: true,
    );
  }

  /// Stop listening.
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  /// Cancel listening without returning a result.
  Future<void> cancel() async {
    _isListening = false;
    await _speech.cancel();
  }

  /// Get available locales for speech recognition.
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) await initialize();
    return await _speech.locales();
  }
}
