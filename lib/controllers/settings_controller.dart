import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/translation_model.dart';

class SettingsController extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _defaultSourceLanguageKey = 'default_source_language';
  static const String _defaultTargetLanguageKey = 'default_target_language';
  static const String _speechRateKey = 'speech_rate';
  static const String _volumeKey = 'volume';
  static const String _autoTranslateKey = 'auto_translate';
  static const String _showPronunciationKey = 'show_pronunciation';
  static const String _offlineModeKey = 'offline_mode';

  SharedPreferences? _prefs;
  
  bool _isDarkMode = false;
  Language _defaultSourceLanguage = Language.english;
  Language _defaultTargetLanguage = Language.sinhala;
  double _speechRate = 0.5;
  double _volume = 1.0;
  bool _autoTranslate = false;
  bool _showPronunciation = true;
  bool _offlineMode = false;
  bool _isInitialized = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  Language get defaultSourceLanguage => _defaultSourceLanguage;
  Language get defaultTargetLanguage => _defaultTargetLanguage;
  double get speechRate => _speechRate;
  double get volume => _volume;
  bool get autoTranslate => _autoTranslate;
  bool get showPronunciation => _showPronunciation;
  bool get offlineMode => _offlineMode;
  bool get isInitialized => _isInitialized;

  // Initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    if (_prefs == null) return;

    _isDarkMode = _prefs!.getBool(_darkModeKey) ?? false;
    
    final sourceLanguageIndex = _prefs!.getInt(_defaultSourceLanguageKey) ?? 0;
    _defaultSourceLanguage = Language.values[sourceLanguageIndex];
    
    final targetLanguageIndex = _prefs!.getInt(_defaultTargetLanguageKey) ?? 1;
    _defaultTargetLanguage = Language.values[targetLanguageIndex];
    
    _speechRate = _prefs!.getDouble(_speechRateKey) ?? 0.5;
    _volume = _prefs!.getDouble(_volumeKey) ?? 1.0;
    _autoTranslate = _prefs!.getBool(_autoTranslateKey) ?? false;
    _showPronunciation = _prefs!.getBool(_showPronunciationKey) ?? true;
    _offlineMode = _prefs!.getBool(_offlineModeKey) ?? false;
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    if (!_isInitialized) await initialize();

    _isDarkMode = !_isDarkMode;
    await _prefs?.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  // Set default source language
  Future<void> setDefaultSourceLanguage(Language language) async {
    if (!_isInitialized) await initialize();

    _defaultSourceLanguage = language;
    await _prefs?.setInt(_defaultSourceLanguageKey, language.index);
    notifyListeners();
  }

  // Set default target language
  Future<void> setDefaultTargetLanguage(Language language) async {
    if (!_isInitialized) await initialize();

    _defaultTargetLanguage = language;
    await _prefs?.setInt(_defaultTargetLanguageKey, language.index);
    notifyListeners();
  }

  // Set speech rate
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) await initialize();

    _speechRate = rate;
    await _prefs?.setDouble(_speechRateKey, rate);
    notifyListeners();
  }

  // Set volume
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) await initialize();

    _volume = volume;
    await _prefs?.setDouble(_volumeKey, volume);
    notifyListeners();
  }

  // Toggle auto translate
  Future<void> toggleAutoTranslate() async {
    if (!_isInitialized) await initialize();

    _autoTranslate = !_autoTranslate;
    await _prefs?.setBool(_autoTranslateKey, _autoTranslate);
    notifyListeners();
  }

  // Toggle show pronunciation
  Future<void> toggleShowPronunciation() async {
    if (!_isInitialized) await initialize();

    _showPronunciation = !_showPronunciation;
    await _prefs?.setBool(_showPronunciationKey, _showPronunciation);
    notifyListeners();
  }

  // Toggle offline mode
  Future<void> toggleOfflineMode() async {
    if (!_isInitialized) await initialize();

    _offlineMode = !_offlineMode;
    await _prefs?.setBool(_offlineModeKey, _offlineMode);
    notifyListeners();
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    if (!_isInitialized) await initialize();

    _isDarkMode = false;
    _defaultSourceLanguage = Language.english;
    _defaultTargetLanguage = Language.sinhala;
    _speechRate = 0.5;
    _volume = 1.0;
    _autoTranslate = false;
    _showPronunciation = true;
    _offlineMode = false;

    // Clear all preferences
    await _prefs?.clear();

    notifyListeners();
  }

  // Get app info
  Map<String, dynamic> getAppInfo() {
    return {
      'version': '1.0.0',
      'buildNumber': '1',
      'developer': 'TriLingo Team',
      'description': 'Sinhala-Tamil-English Translator Plus - Academic Language Helper',
    };
  }

  // Get usage statistics
  Map<String, dynamic> getUsageStats() {
    // This would typically come from analytics or database
    return {
      'totalTranslations': 0,
      'favoriteWords': 0,
      'studySessionsCompleted': 0,
      'averageAccuracy': 0.0,
    };
  }

  // Export user data
  Future<Map<String, dynamic>> exportUserData() async {
    return {
      'settings': {
        'isDarkMode': _isDarkMode,
        'defaultSourceLanguage': _defaultSourceLanguage.name,
        'defaultTargetLanguage': _defaultTargetLanguage.name,
        'speechRate': _speechRate,
        'volume': _volume,
        'autoTranslate': _autoTranslate,
        'showPronunciation': _showPronunciation,
        'offlineMode': _offlineMode,
      },
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Import user data
  Future<void> importUserData(Map<String, dynamic> data) async {
    if (!_isInitialized) await initialize();

    try {
      final settings = data['settings'] as Map<String, dynamic>?;
      if (settings != null) {
        _isDarkMode = settings['isDarkMode'] ?? false;
        _speechRate = settings['speechRate']?.toDouble() ?? 0.5;
        _volume = settings['volume']?.toDouble() ?? 1.0;
        _autoTranslate = settings['autoTranslate'] ?? false;
        _showPronunciation = settings['showPronunciation'] ?? true;
        _offlineMode = settings['offlineMode'] ?? false;

        // Parse languages
        final sourceLanguageName = settings['defaultSourceLanguage'] as String?;
        if (sourceLanguageName != null) {
          _defaultSourceLanguage = Language.values.firstWhere(
            (l) => l.name == sourceLanguageName,
            orElse: () => Language.english,
          );
        }

        final targetLanguageName = settings['defaultTargetLanguage'] as String?;
        if (targetLanguageName != null) {
          _defaultTargetLanguage = Language.values.firstWhere(
            (l) => l.name == targetLanguageName,
            orElse: () => Language.sinhala,
          );
        }

        // Save to preferences
        await _saveAllSettings();
        notifyListeners();
      }
    } catch (e) {
      print('Error importing user data: $e');
    }
  }

  // Save all settings to SharedPreferences
  Future<void> _saveAllSettings() async {
    if (_prefs == null) return;

    await _prefs!.setBool(_darkModeKey, _isDarkMode);
    await _prefs!.setInt(_defaultSourceLanguageKey, _defaultSourceLanguage.index);
    await _prefs!.setInt(_defaultTargetLanguageKey, _defaultTargetLanguage.index);
    await _prefs!.setDouble(_speechRateKey, _speechRate);
    await _prefs!.setDouble(_volumeKey, _volume);
    await _prefs!.setBool(_autoTranslateKey, _autoTranslate);
    await _prefs!.setBool(_showPronunciationKey, _showPronunciation);
    await _prefs!.setBool(_offlineModeKey, _offlineMode);
  }
}
