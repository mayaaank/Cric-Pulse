import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _darkMode = 'darkMode';
  static const _liveNotif = 'liveNotif';
  static const _scoreNotif = 'scoreNotif';
  static const _language = 'language';

  Future<Map<String, dynamic>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      _darkMode: prefs.getBool(_darkMode) ?? true,
      _liveNotif: prefs.getBool(_liveNotif) ?? true,
      _scoreNotif: prefs.getBool(_scoreNotif) ?? false,
      _language: prefs.getString(_language) ?? 'English',
    };
  }

  Future<void> setDarkMode(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_darkMode, v);
  Future<void> setLiveNotif(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_liveNotif, v);
  Future<void> setScoreNotif(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_scoreNotif, v);
  Future<void> setLanguage(String v) async =>
      (await SharedPreferences.getInstance()).setString(_language, v);
}
