enum Language { sinhala, tamil, english }

class Translation {
  final String id;
  final String sourceText;
  final String translatedText;
  final Language sourceLanguage;
  final Language targetLanguage;
  final DateTime timestamp;
  final bool isFavorite;

  Translation({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.timestamp,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage.name,
      'targetLanguage': targetLanguage.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      id: map['id'],
      sourceText: map['sourceText'],
      translatedText: map['translatedText'],
      sourceLanguage: Language.values.firstWhere(
        (e) => e.name == map['sourceLanguage'],
      ),
      targetLanguage: Language.values.firstWhere(
        (e) => e.name == map['targetLanguage'],
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Translation copyWith({
    String? id,
    String? sourceText,
    String? translatedText,
    Language? sourceLanguage,
    Language? targetLanguage,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return Translation(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

extension LanguageExtension on Language {
  String get displayName {
    switch (this) {
      case Language.sinhala:
        return 'සිංහල';
      case Language.tamil:
        return 'தமிழ்';
      case Language.english:
        return 'English';
    }
  }

  String get code {
    switch (this) {
      case Language.sinhala:
        return 'si';
      case Language.tamil:
        return 'ta';
      case Language.english:
        return 'en';
    }
  }
}
