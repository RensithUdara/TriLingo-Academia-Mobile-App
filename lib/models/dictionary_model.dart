import 'translation_model.dart';

enum DictionaryCategory {
  medicine,
  engineering,
  law,
  general,
  anatomy,
  pharmacy,
  clinical,
  technical,
  legal,
}

class DictionaryEntry {
  final String id;
  final String englishTerm;
  final String sinhalaTerm;
  final String tamilTerm;
  final String definition;
  final String pronunciation;
  final DictionaryCategory category;
  final List<String> synonyms;
  final List<String> examples;
  final bool isFavorite;
  final DateTime createdAt;

  DictionaryEntry({
    required this.id,
    required this.englishTerm,
    required this.sinhalaTerm,
    required this.tamilTerm,
    required this.definition,
    this.pronunciation = '',
    required this.category,
    this.synonyms = const [],
    this.examples = const [],
    this.isFavorite = false,
    required this.createdAt,
  });

  String getTermByLanguage(Language language) {
    switch (language) {
      case Language.english:
        return englishTerm;
      case Language.sinhala:
        return sinhalaTerm;
      case Language.tamil:
        return tamilTerm;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'englishTerm': englishTerm,
      'sinhalaTerm': sinhalaTerm,
      'tamilTerm': tamilTerm,
      'definition': definition,
      'pronunciation': pronunciation,
      'category': category.name,
      'synonyms': synonyms.join('|'),
      'examples': examples.join('|'),
      'isFavorite': isFavorite ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DictionaryEntry.fromMap(Map<String, dynamic> map) {
    return DictionaryEntry(
      id: map['id'],
      englishTerm: map['englishTerm'],
      sinhalaTerm: map['sinhalaTerm'],
      tamilTerm: map['tamilTerm'],
      definition: map['definition'],
      pronunciation: map['pronunciation'] ?? '',
      category: DictionaryCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => DictionaryCategory.general,
      ),
      synonyms: map['synonyms']?.split('|') ?? [],
      examples: map['examples']?.split('|') ?? [],
      isFavorite: map['isFavorite'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  DictionaryEntry copyWith({
    String? id,
    String? englishTerm,
    String? sinhalaTerm,
    String? tamilTerm,
    String? definition,
    String? pronunciation,
    DictionaryCategory? category,
    List<String>? synonyms,
    List<String>? examples,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return DictionaryEntry(
      id: id ?? this.id,
      englishTerm: englishTerm ?? this.englishTerm,
      sinhalaTerm: sinhalaTerm ?? this.sinhalaTerm,
      tamilTerm: tamilTerm ?? this.tamilTerm,
      definition: definition ?? this.definition,
      pronunciation: pronunciation ?? this.pronunciation,
      category: category ?? this.category,
      synonyms: synonyms ?? this.synonyms,
      examples: examples ?? this.examples,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension DictionaryCategoryExtension on DictionaryCategory {
  String get displayName {
    switch (this) {
      case DictionaryCategory.medicine:
        return 'Medicine';
      case DictionaryCategory.engineering:
        return 'Engineering';
      case DictionaryCategory.law:
        return 'Law';
      case DictionaryCategory.general:
        return 'General';
      case DictionaryCategory.anatomy:
        return 'Anatomy & Physiology';
      case DictionaryCategory.pharmacy:
        return 'Pharmacy';
      case DictionaryCategory.clinical:
        return 'Clinical';
      case DictionaryCategory.technical:
        return 'Technical';
      case DictionaryCategory.legal:
        return 'Legal';
    }
  }

  String get icon {
    switch (this) {
      case DictionaryCategory.medicine:
        return '🏥';
      case DictionaryCategory.engineering:
        return '⚙️';
      case DictionaryCategory.law:
        return '⚖️';
      case DictionaryCategory.general:
        return '📚';
      case DictionaryCategory.anatomy:
        return '🫀';
      case DictionaryCategory.pharmacy:
        return '💊';
      case DictionaryCategory.clinical:
        return '🩺';
      case DictionaryCategory.technical:
        return '🔧';
      case DictionaryCategory.legal:
        return '📜';
    }
  }
}
