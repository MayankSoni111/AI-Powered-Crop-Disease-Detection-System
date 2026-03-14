import 'package:flutter/material.dart';
import 'lang_en.dart';
import 'lang_hi.dart';
import 'lang_pa.dart';
import 'lang_mr.dart';
import 'lang_gu.dart';
import 'lang_ta.dart';
import 'lang_te.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('pa'),
    Locale('mr'),
    Locale('gu'),
    Locale('ta'),
    Locale('te'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': enTranslations,
    'hi': hiTranslations,
    'pa': paTranslations,
    'mr': mrTranslations,
    'gu': guTranslations,
    'ta': taTranslations,
    'te': teTranslations,
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'pa', 'mr', 'gu', 'ta', 'te']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Convenience extension for easy access
extension LocalizationExt on BuildContext {
  String tr(String key) =>
      AppLocalizations.of(this)?.translate(key) ?? key;
}
