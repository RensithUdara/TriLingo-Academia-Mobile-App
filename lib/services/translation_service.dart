import '../models/translation_model.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  // Offline translation dictionary
  final Map<String, Map<String, String>> _offlineTranslations = {
    'medicine': {
      'heart': 'හෘදය|இதயம்',
      'blood': 'රුධිරය|இரத்தம்',
      'pressure': 'පීඩනය|அழுத்தம்',
      'surgery': 'ශල්‍යකර්මය|அறுவை சிகிச்சை',
      'medicine': 'ඖෂධය|மருந்து',
      'doctor': 'වෛද්‍යවරයා|மருத்துவர்',
      'hospital': 'රෝහල|மருத்துவமனை',
      'patient': 'රෝගියා|நோயாளி',
      'treatment': 'ප්‍රතිකාරය|சிகிச்சை',
      'diagnosis': 'රෝග නිශ්චය|நோய் கண்டறிதல்',
    },
    'engineering': {
      'circuit': 'පරිපථය|மின்சுற்று',
      'foundation': 'අත්තිවාර|அடித்தளம்',
      'algorithm': 'ඇල්ගොරිතම|வழிமுறை',
      'machine': 'යන්ත්‍රය|இயந்திரம்',
      'structure': 'ව්‍යුහය|கட்டமைப்பு',
      'design': 'සැලසුම|வடிவமைப்பு',
      'project': 'ව්‍යාපෘතිය|திட்டம்',
      'technology': 'තාක්ෂණය|தொழில்நுட்பம்',
      'system': 'පද්ධතිය|அமைப்பு',
      'process': 'ක්‍රියාවලිය|செயல்முறை',
    },
    'law': {
      'contract': 'කොන්ත්‍රාත්තුව|ஒப்பந்தம்',
      'evidence': 'සාක්ෂි|சாக்ஷி',
      'appeal': 'අභියාචනය|மேல்முறையீடு',
      'court': 'උසාවිය|நீதிமன்றம்',
      'judge': 'විනිසුරු|நீதிபதி',
      'lawyer': 'නීතිඥයා|வழக்கறிஞர்',
      'law': 'නීතිය|சட்டம்',
      'justice': 'යුක්තිය|நீதி',
      'rights': 'අයිතිවාසිකම්|உரிமைகள்',
      'constitution': 'ව්‍යවස්ථාව|அரசியலமைப்பு',
    },
    'general': {
      'hello': 'හෙලෝ|வணக்கம்',
      'goodbye': 'ආයුබෝවන්|விடைபெறல்',
      'thank you': 'ස්තූතියි|நன்றி',
      'please': 'කරුණාකර|தயவுசெய்து',
      'yes': 'ඔව්|ஆம்',
      'no': 'නැහැ|இல்லை',
      'good morning': 'සුභ උදෑසනක්|காலை வணக்கம்',
      'good night': 'සුභ රාත්‍රියක්|இரவு வணக்கம்',
      'how are you': 'කොහොමද|எப்படி இருக்கின்றீர்கள்',
      'what is your name': 'ඔබගේ නම මොකක්ද|உங்கள் பெயர் என்ன',
    }
  };

  Future<String> translateText(
    String text, 
    Language sourceLanguage, 
    Language targetLanguage
  ) async {
    try {
      // First try offline translation
      String? offlineResult = _getOfflineTranslation(text, sourceLanguage, targetLanguage);
      if (offlineResult != null) {
        return offlineResult;
      }

      // If offline fails, try online translation (mock for now)
      return await _getOnlineTranslation(text, sourceLanguage, targetLanguage);
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }

  String? _getOfflineTranslation(String text, Language sourceLanguage, Language targetLanguage) {
    final normalizedText = text.toLowerCase().trim();
    
    // Search through all categories
    for (final category in _offlineTranslations.values) {
      for (final entry in category.entries) {
        if (entry.key.toLowerCase() == normalizedText) {
          final translations = entry.value.split('|');
          switch (targetLanguage) {
            case Language.sinhala:
              return translations[0];
            case Language.tamil:
              return translations[1];
            case Language.english:
              return entry.key;
          }
        }
      }
    }
    
    return null;
  }

  Future<String> _getOnlineTranslation(
    String text, 
    Language sourceLanguage, 
    Language targetLanguage
  ) async {
    // Mock online translation - in real app, integrate with Google Translate API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simple rule-based translation for demo
    if (sourceLanguage == Language.english) {
      switch (targetLanguage) {
        case Language.sinhala:
          return _mockTranslateToSinhala(text);
        case Language.tamil:
          return _mockTranslateToTamil(text);
        case Language.english:
          return text;
      }
    }
    
    return 'Translation not available offline';
  }

  String _mockTranslateToSinhala(String text) {
    final commonTranslations = {
      'hello': 'හෙලෝ',
      'good': 'හොඳ',
      'bad': 'නරක',
      'big': 'ලොකු',
      'small': 'පොඩි',
      'water': 'වතුර',
      'food': 'කෑම',
      'book': 'පොත',
      'school': 'පාසල',
      'house': 'ගෙදර',
    };
    
    return commonTranslations[text.toLowerCase()] ?? '$text (අර්ථකථනය නොමැත)';
  }

  String _mockTranslateToTamil(String text) {
    final commonTranslations = {
      'hello': 'வணக்கம்',
      'good': 'நல்ல',
      'bad': 'மோசமான',
      'big': 'பெரிய',
      'small': 'சிறிய',
      'water': 'தண்ணீர்',
      'food': 'உணவு',
      'book': 'புத்தகம்',
      'school': 'பள்ளி',
      'house': 'வீடு',
    };
    
    return commonTranslations[text.toLowerCase()] ?? '$text (மொழிபெயர்ப்பு கிடைக்கவில்லை)';
  }

  Language detectLanguage(String text) {
    // Simple language detection based on Unicode ranges
    if (_containsSinhalaChars(text)) {
      return Language.sinhala;
    } else if (_containsTamilChars(text)) {
      return Language.tamil;
    } else {
      return Language.english;
    }
  }

  bool _containsSinhalaChars(String text) {
    return text.contains(RegExp(r'[\u0D80-\u0DFF]'));
  }

  bool _containsTamilChars(String text) {
    return text.contains(RegExp(r'[\u0B80-\u0BFF]'));
  }

  List<String> getSuggestions(String query, Language language) {
    final suggestions = <String>[];
    
    for (final category in _offlineTranslations.values) {
      for (final entry in category.entries) {
        if (entry.key.toLowerCase().contains(query.toLowerCase())) {
          suggestions.add(entry.key);
        }
      }
    }
    
    return suggestions.take(5).toList();
  }
}
