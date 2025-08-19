import 'package:flutter/material.dart';
import '../models/translation_model.dart';
import '../services/audio_service.dart';

class AudioController extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isListening = false;
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  String? _lastSpokenText;
  Language? _lastSpokenLanguage;
  String? _listeningResult;
  String? _error;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isListening => _isListening;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;
  String? get lastSpokenText => _lastSpokenText;
  Language? get lastSpokenLanguage => _lastSpokenLanguage;
  String? get listeningResult => _listeningResult;
  String? get error => _error;

  // Initialize audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _audioService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Speak text
  Future<void> speak(String text, Language language) async {
    if (!_isInitialized) await initialize();

    try {
      _isPlaying = true;
      _lastSpokenText = text;
      _lastSpokenLanguage = language;
      _error = null;
      notifyListeners();

      await _audioService.speak(text, language);

      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isPlaying = false;
      notifyListeners();
    }
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    if (!_isInitialized) return;

    try {
      await _audioService.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Pause speaking
  Future<void> pauseSpeaking() async {
    if (!_isInitialized) return;

    try {
      await _audioService.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Start listening for speech input
  Future<void> startListening({Language language = Language.english}) async {
    if (!_isInitialized) await initialize();

    try {
      _isListening = true;
      _listeningResult = null;
      _error = null;
      notifyListeners();

      await _audioService.startListening(language: language);
      
      // Note: The actual result will come through the SpeechToText callback
      // This is a simplified implementation
    } catch (e) {
      _error = e.toString();
      _isListening = false;
      notifyListeners();
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    if (!_isInitialized) return;

    try {
      await _audioService.stopListening();
      _isListening = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isListening = false;
      notifyListeners();
    }
  }

  // Set speech rate
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) await initialize();

    try {
      await _audioService.setSpeechRate(rate);
      _speechRate = rate;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Set volume
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) await initialize();

    try {
      await _audioService.setVolume(volume);
      _volume = volume;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Set pitch
  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) await initialize();

    try {
      await _audioService.setPitch(pitch);
      _pitch = pitch;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get pronunciation guide
  String getPronunciationGuide(String word, Language language) {
    return _audioService.getPronunciationGuide(word, language);
  }

  // Get available languages
  Future<List<String>> getAvailableLanguages() async {
    if (!_isInitialized) await initialize();

    try {
      return await _audioService.getAvailableLanguages();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Repeat last spoken text
  Future<void> repeatLastSpoken() async {
    if (_lastSpokenText != null && _lastSpokenLanguage != null) {
      await speak(_lastSpokenText!, _lastSpokenLanguage!);
    }
  }

  // Set listening result (called from speech recognition callback)
  void setListeningResult(String result) {
    _listeningResult = result;
    _isListening = false;
    notifyListeners();
  }

  // Clear listening result
  void clearListeningResult() {
    _listeningResult = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Check if audio service is available
  bool get isAudioAvailable => _audioService.isAvailable;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
