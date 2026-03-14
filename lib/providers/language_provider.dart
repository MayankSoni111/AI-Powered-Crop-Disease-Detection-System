import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  final SharedPreferences _prefs;
  Locale _locale;
  bool _isFirstLaunch;

  LanguageProvider(this._prefs)
      : _locale = Locale(_prefs.getString(_languageKey) ?? 'en'),
        _isFirstLaunch = !_prefs.containsKey(_languageKey);

  Locale get locale => _locale;
  bool get isFirstLaunch => _isFirstLaunch;
  String get languageCode => _locale.languageCode;

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'pa': 'ਪੰਜਾਬੀ',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
  };

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    _isFirstLaunch = false;
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  String getLanguageName(String code) {
    return supportedLanguages[code] ?? code;
  }
}
