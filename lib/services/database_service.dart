import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/translation_model.dart';
import '../models/dictionary_model.dart';
import '../models/flashcard_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trilingo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Translations table
    await db.execute('''
      CREATE TABLE translations(
        id TEXT PRIMARY KEY,
        sourceText TEXT NOT NULL,
        translatedText TEXT NOT NULL,
        sourceLanguage TEXT NOT NULL,
        targetLanguage TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Dictionary table
    await db.execute('''
      CREATE TABLE dictionary(
        id TEXT PRIMARY KEY,
        englishTerm TEXT NOT NULL,
        sinhalaTerm TEXT NOT NULL,
        tamilTerm TEXT NOT NULL,
        definition TEXT NOT NULL,
        pronunciation TEXT,
        category TEXT NOT NULL,
        synonyms TEXT,
        examples TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Flashcards table
    await db.execute('''
      CREATE TABLE flashcards(
        id TEXT PRIMARY KEY,
        front TEXT NOT NULL,
        back TEXT NOT NULL,
        frontLanguage TEXT NOT NULL,
        backLanguage TEXT NOT NULL,
        category TEXT NOT NULL,
        difficulty INTEGER NOT NULL DEFAULT 3,
        repetitions INTEGER NOT NULL DEFAULT 0,
        lastReviewed INTEGER NOT NULL,
        nextReview INTEGER NOT NULL,
        isLearned INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Study sessions table
    await db.execute('''
      CREATE TABLE study_sessions(
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        startTime INTEGER NOT NULL,
        endTime INTEGER,
        cardsReviewed INTEGER NOT NULL DEFAULT 0,
        correctAnswers INTEGER NOT NULL DEFAULT 0,
        incorrectAnswers INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert sample dictionary data
    await _insertSampleData(db);
  }

  Future<void> initDatabase() async {
    await database;
  }

  // Translation methods
  Future<String> insertTranslation(Translation translation) async {
    final db = await instance.database;
    await db.insert('translations', translation.toMap());
    return translation.id;
  }

  Future<List<Translation>> getTranslations({int? limit}) async {
    final db = await instance.database;
    final result = await db.query(
      'translations',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return result.map((map) => Translation.fromMap(map)).toList();
  }

  Future<List<Translation>> getFavoriteTranslations() async {
    final db = await instance.database;
    final result = await db.query(
      'translations',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => Translation.fromMap(map)).toList();
  }

  Future<void> updateTranslation(Translation translation) async {
    final db = await instance.database;
    await db.update(
      'translations',
      translation.toMap(),
      where: 'id = ?',
      whereArgs: [translation.id],
    );
  }

  Future<void> deleteTranslation(String id) async {
    final db = await instance.database;
    await db.delete(
      'translations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Dictionary methods
  Future<String> insertDictionaryEntry(DictionaryEntry entry) async {
    final db = await instance.database;
    await db.insert('dictionary', entry.toMap());
    return entry.id;
  }

  Future<List<DictionaryEntry>> searchDictionary(String query, {DictionaryCategory? category}) async {
    final db = await instance.database;
    String whereClause = 'englishTerm LIKE ? OR sinhalaTerm LIKE ? OR tamilTerm LIKE ?';
    List<dynamic> whereArgs = ['%$query%', '%$query%', '%$query%'];

    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category.name);
    }

    final result = await db.query(
      'dictionary',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'englishTerm ASC',
    );
    return result.map((map) => DictionaryEntry.fromMap(map)).toList();
  }

  Future<List<DictionaryEntry>> getDictionaryByCategory(DictionaryCategory category) async {
    final db = await instance.database;
    final result = await db.query(
      'dictionary',
      where: 'category = ?',
      whereArgs: [category.name],
      orderBy: 'englishTerm ASC',
    );
    return result.map((map) => DictionaryEntry.fromMap(map)).toList();
  }

  Future<List<DictionaryEntry>> getFavoriteDictionaryEntries() async {
    final db = await instance.database;
    final result = await db.query(
      'dictionary',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'englishTerm ASC',
    );
    return result.map((map) => DictionaryEntry.fromMap(map)).toList();
  }

  Future<void> updateDictionaryEntry(DictionaryEntry entry) async {
    final db = await instance.database;
    await db.update(
      'dictionary',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Flashcard methods
  Future<String> insertFlashcard(Flashcard flashcard) async {
    final db = await instance.database;
    await db.insert('flashcards', flashcard.toMap());
    return flashcard.id;
  }

  Future<List<Flashcard>> getFlashcardsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'flashcards',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'nextReview ASC',
    );
    return result.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<List<Flashcard>> getDueFlashcards() async {
    final db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final result = await db.query(
      'flashcards',
      where: 'nextReview <= ? AND isLearned = 0',
      whereArgs: [now],
      orderBy: 'nextReview ASC',
    );
    return result.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    final db = await instance.database;
    await db.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  // Study session methods
  Future<String> insertStudySession(StudySession session) async {
    final db = await instance.database;
    await db.insert('study_sessions', session.toMap());
    return session.id;
  }

  Future<List<StudySession>> getStudySessions({int? limit}) async {
    final db = await instance.database;
    final result = await db.query(
      'study_sessions',
      orderBy: 'startTime DESC',
      limit: limit,
    );
    return result.map((map) => StudySession.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> _insertSampleData(Database db) async {
    // Sample medical dictionary entries
    final medicalEntries = [
      {
        'id': 'med_001',
        'englishTerm': 'Heart',
        'sinhalaTerm': 'හෘදය',
        'tamilTerm': 'இதயம்',
        'definition': 'The muscular organ that pumps blood through the body',
        'pronunciation': 'hahrt',
        'category': 'medicine',
        'synonyms': 'cardiac muscle',
        'examples': 'The heart beats approximately 100,000 times per day',
        'isFavorite': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'med_002',
        'englishTerm': 'Blood Pressure',
        'sinhalaTerm': 'රුධිර පීඩනය',
        'tamilTerm': 'இரத்த அழுத்தம்',
        'definition': 'The pressure of blood against the walls of arteries',
        'pronunciation': 'bluhd presh-er',
        'category': 'medicine',
        'synonyms': 'arterial pressure',
        'examples': 'Normal blood pressure is around 120/80 mmHg',
        'isFavorite': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final entry in medicalEntries) {
      await db.insert('dictionary', entry);
    }
  }
}
