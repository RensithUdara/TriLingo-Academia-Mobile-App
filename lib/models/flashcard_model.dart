import 'translation_model.dart';

class Flashcard {
  final String id;
  final String front;
  final String back;
  final Language frontLanguage;
  final Language backLanguage;
  final String category;
  final int difficulty; // 1-5 scale
  final int repetitions;
  final DateTime lastReviewed;
  final DateTime nextReview;
  final bool isLearned;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.frontLanguage,
    required this.backLanguage,
    required this.category,
    this.difficulty = 3,
    this.repetitions = 0,
    required this.lastReviewed,
    required this.nextReview,
    this.isLearned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'frontLanguage': frontLanguage.name,
      'backLanguage': backLanguage.name,
      'category': category,
      'difficulty': difficulty,
      'repetitions': repetitions,
      'lastReviewed': lastReviewed.millisecondsSinceEpoch,
      'nextReview': nextReview.millisecondsSinceEpoch,
      'isLearned': isLearned ? 1 : 0,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      front: map['front'],
      back: map['back'],
      frontLanguage: Language.values.firstWhere(
        (e) => e.name == map['frontLanguage'],
      ),
      backLanguage: Language.values.firstWhere(
        (e) => e.name == map['backLanguage'],
      ),
      category: map['category'],
      difficulty: map['difficulty'],
      repetitions: map['repetitions'],
      lastReviewed: DateTime.fromMillisecondsSinceEpoch(map['lastReviewed']),
      nextReview: DateTime.fromMillisecondsSinceEpoch(map['nextReview']),
      isLearned: map['isLearned'] == 1,
    );
  }

  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    Language? frontLanguage,
    Language? backLanguage,
    String? category,
    int? difficulty,
    int? repetitions,
    DateTime? lastReviewed,
    DateTime? nextReview,
    bool? isLearned,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      frontLanguage: frontLanguage ?? this.frontLanguage,
      backLanguage: backLanguage ?? this.backLanguage,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      repetitions: repetitions ?? this.repetitions,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      isLearned: isLearned ?? this.isLearned,
    );
  }
}

class StudySession {
  final String id;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final int cardsReviewed;
  final int correctAnswers;
  final int incorrectAnswers;
  final double accuracy;

  StudySession({
    required this.id,
    required this.category,
    required this.startTime,
    this.endTime,
    this.cardsReviewed = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
  }) : accuracy = cardsReviewed > 0 ? (correctAnswers / cardsReviewed) * 100 : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'cardsReviewed': cardsReviewed,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      category: map['category'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: map['endTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
          : null,
      cardsReviewed: map['cardsReviewed'],
      correctAnswers: map['correctAnswers'],
      incorrectAnswers: map['incorrectAnswers'],
    );
  }
}
