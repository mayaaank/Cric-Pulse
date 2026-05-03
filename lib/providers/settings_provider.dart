import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();

  bool _darkMode = true;
  bool _liveNotif = true;
  bool _scoreNotif = false;
  String _language = 'English';
  bool _loaded = false;

  bool get darkMode => _darkMode;
  bool get liveNotif => _liveNotif;
  bool get scoreNotif => _scoreNotif;
  String get language => _language;
  bool get loaded => _loaded;

  static const languages = ['English', 'Hindi', 'Urdu'];

  Future<void> load() async {
    final data = await _service.load();
    _darkMode = data['darkMode'] as bool;
    _liveNotif = data['liveNotif'] as bool;
    _scoreNotif = data['scoreNotif'] as bool;
    _language = data['language'] as String;
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    await _service.setDarkMode(_darkMode);
  }

  Future<void> toggleLiveNotif() async {
    _liveNotif = !_liveNotif;
    notifyListeners();
    await _service.setLiveNotif(_liveNotif);
  }

  Future<void> toggleScoreNotif() async {
    _scoreNotif = !_scoreNotif;
    notifyListeners();
    await _service.setScoreNotif(_scoreNotif);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    await _service.setLanguage(lang);
  }
}
