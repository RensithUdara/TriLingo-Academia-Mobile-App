import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/translation_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late FlutterTts _flutterTts;
  late SpeechToText _speechToText;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();
    _speechToText = SpeechToText();

    await _initializeTts();
    await _initializeStt();
    
    _isInitialized = true;
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initializeStt() async {
    await _speechToText.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (error) => print('Speech recognition error: $error'),
    );
  }

  Future<void> speak(String text, Language language) async {
    if (!_isInitialized) await initialize();

    try {
      // Set language-specific TTS settings
      await _setLanguageForTts(language);
      await _flutterTts.speak(text);
    } catch (e) {
      throw Exception('Text-to-speech failed: $e');
    }
  }

  Future<void> _setLanguageForTts(Language language) async {
    switch (language) {
      case Language.english:
        await _flutterTts.setLanguage("en-US");
        break;
      case Language.sinhala:
        await _flutterTts.setLanguage("si-LK");
        break;
      case Language.tamil:
        await _flutterTts.setLanguage("ta-IN");
        break;
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    if (!_isInitialized) return;
    await _flutterTts.pause();
  }

  Future<String?> startListening({Language language = Language.english}) async {
    if (!_isInitialized) await initialize();

    if (!_speechToText.isAvailable) {
      throw Exception('Speech recognition not available');
    }

    final localeId = _getLocaleId(language);
    
    try {
      bool available = await _speechToText.listen(
        onResult: (result) {
          // Result will be handled by the controller
        },
        localeId: localeId,
        listenMode: ListenMode.confirmation,
      );

      if (!available) {
        throw Exception('Speech recognition not available');
      }

      return null; // Result will come through onResult callback
    } catch (e) {
      throw Exception('Speech recognition failed: $e');
    }
  }

  String _getLocaleId(Language language) {
    switch (language) {
      case Language.english:
        return 'en_US';
      case Language.sinhala:
        return 'si_LK';
      case Language.tamil:
        return 'ta_IN';
    }
  }

  Future<void> stopListening() async {
    if (!_isInitialized) return;
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _speechToText.isAvailable;

  Future<List<String>> getAvailableLanguages() async {
    if (!_isInitialized) await initialize();
    
    final languages = await _flutterTts.getLanguages;
    return List<String>.from(languages ?? []);
  }

  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) await initialize();
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setVolume(double volume) async {
    if (!_isInitialized) await initialize();
    await _flutterTts.setVolume(volume);
  }

  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) await initialize();
    await _flutterTts.setPitch(pitch);
  }

  // Get pronunciation guide for complex words
  String getPronunciationGuide(String word, Language language) {
    final pronunciationMap = {
      Language.sinhala: {
        'හෘදය': 'hru-da-ya',
        'රුධිරය': 'ru-dhi-ra-ya',
        'ශල්‍යකර්මය': 'shal-ya-kar-ma-ya',
        'වෛද්‍යවරයා': 'wai-dya-wa-ra-ya',
        'ප්‍රතිකාරය': 'pra-ti-ka-ra-ya',
      },
      Language.tamil: {
        'இதயம்': 'i-tha-yam',
        'இரத்தம்': 'i-rat-tham',
        'அறுவை சிகிச்சை': 'a-ru-vai si-kit-chai',
        'மருத்துவர்': 'ma-ruth-thu-var',
        'சிகிச்சை': 'si-kit-chai',
      },
      Language.english: {
        'pronunciation': 'pro-nun-see-ay-shun',
        'medicine': 'med-uh-sin',
        'engineering': 'en-juh-neer-ing',
        'algorithm': 'al-guh-ri-thuhm',
        'diagnosis': 'dahy-uhg-noh-sis',
      },
    };

    return pronunciationMap[language]?[word] ?? word;
  }

  void dispose() {
    _flutterTts.stop();
    _speechToText.stop();
  }
}
