import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/translation_model.dart';
import '../services/translation_service.dart';
import '../services/database_service.dart';

class TranslationController extends ChangeNotifier {
  final TranslationService _translationService = TranslationService();
  final DatabaseService _databaseService = DatabaseService.instance;
  final Uuid _uuid = const Uuid();

  List<Translation> _translations = [];
  List<Translation> _favoriteTranslations = [];
  String _currentInput = '';
  Language _sourceLanguage = Language.english;
  Language _targetLanguage = Language.sinhala;
  bool _isLoading = false;
  String? _error;
  List<String> _suggestions = [];

  // Getters
  List<Translation> get translations => _translations;
  List<Translation> get favoriteTranslations => _favoriteTranslations;
  String get currentInput => _currentInput;
  Language get sourceLanguage => _sourceLanguage;
  Language get targetLanguage => _targetLanguage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get suggestions => _suggestions;

  // Initialize
  Future<void> initialize() async {
    await loadTranslations();
    await loadFavoriteTranslations();
  }

  // Load translations from database
  Future<void> loadTranslations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _translations = await _databaseService.getTranslations(limit: 50);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load favorite translations
  Future<void> loadFavoriteTranslations() async {
    try {
      _favoriteTranslations = await _databaseService.getFavoriteTranslations();
      notifyListeners();
    } catch (e) {
      print('Error loading favorite translations: $e');
    }
  }

  // Set input text
  void setInput(String input) {
    _currentInput = input;
    
    // Auto-detect language
    if (input.isNotEmpty) {
      _sourceLanguage = _translationService.detectLanguage(input);
    }
    
    // Get suggestions
    _suggestions = _translationService.getSuggestions(input, _sourceLanguage);
    
    notifyListeners();
  }

  // Set source language
  void setSourceLanguage(Language language) {
    if (_sourceLanguage != language) {
      _sourceLanguage = language;
      notifyListeners();
    }
  }

  // Set target language
  void setTargetLanguage(Language language) {
    if (_targetLanguage != language) {
      _targetLanguage = language;
      notifyListeners();
    }
  }

  // Swap languages
  void swapLanguages() {
    final temp = _sourceLanguage;
    _sourceLanguage = _targetLanguage;
    _targetLanguage = temp;
    notifyListeners();
  }

  // Translate text
  Future<Translation?> translateText(String? inputText) async {
    final text = inputText ?? _currentInput;
    if (text.isEmpty) return null;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final translatedText = await _translationService.translateText(
        text,
        _sourceLanguage,
        _targetLanguage,
      );

      final translation = Translation(
        id: _uuid.v4(),
        sourceText: text,
        translatedText: translatedText,
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
        timestamp: DateTime.now(),
      );

      // Save to database
      await _databaseService.insertTranslation(translation);
      
      // Add to local list
      _translations.insert(0, translation);
      
      _isLoading = false;
      notifyListeners();
      
      return translation;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Translation translation) async {
    try {
      final updatedTranslation = translation.copyWith(
        isFavorite: !translation.isFavorite,
      );

      await _databaseService.updateTranslation(updatedTranslation);

      // Update local lists
      final index = _translations.indexWhere((t) => t.id == translation.id);
      if (index != -1) {
        _translations[index] = updatedTranslation;
      }

      if (updatedTranslation.isFavorite) {
        _favoriteTranslations.insert(0, updatedTranslation);
      } else {
        _favoriteTranslations.removeWhere((t) => t.id == translation.id);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete translation
  Future<void> deleteTranslation(Translation translation) async {
    try {
      await _databaseService.deleteTranslation(translation.id);

      _translations.removeWhere((t) => t.id == translation.id);
      _favoriteTranslations.removeWhere((t) => t.id == translation.id);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear all translations
  Future<void> clearTranslations() async {
    try {
      for (final translation in _translations) {
        await _databaseService.deleteTranslation(translation.id);
      }

      _translations.clear();
      _favoriteTranslations.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear current input
  void clearInput() {
    _currentInput = '';
    _suggestions.clear();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
