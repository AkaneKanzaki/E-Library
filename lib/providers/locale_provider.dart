import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English
  
  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      // Use platform locale or default to 'id'
      try {
        final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
        if (platformLocale.languageCode == 'id') {
          _locale = const Locale('id');
        } else {
          _locale = const Locale('en');
        }
      } catch (_) {
        _locale = const Locale('en');
      }
    }
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (!['en', 'id'].contains(locale.languageCode)) return;
    _locale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'id') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('id'));
    }
  }


  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }
}
