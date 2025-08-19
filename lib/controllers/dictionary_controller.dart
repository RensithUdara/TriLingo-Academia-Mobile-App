import 'package:flutter/material.dart';
import '../models/dictionary_model.dart';
import '../models/translation_model.dart';
import '../services/database_service.dart';

class DictionaryController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<DictionaryEntry> _entries = [];
  List<DictionaryEntry> _searchResults = [];
  List<DictionaryEntry> _favoriteEntries = [];
  DictionaryCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<DictionaryEntry> get entries => _entries;
  List<DictionaryEntry> get searchResults => _searchResults;
  List<DictionaryEntry> get favoriteEntries => _favoriteEntries;
  DictionaryCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<DictionaryCategory> get availableCategories => DictionaryCategory.values;

  // Initialize
  Future<void> initialize() async {
    await loadFavoriteEntries();
    if (_selectedCategory != null) {
      await loadEntriesByCategory(_selectedCategory!);
    }
  }

  // Search dictionary
  Future<void> searchDictionary(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      _searchQuery = '';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      _searchQuery = query;
      notifyListeners();

      _searchResults = await _databaseService.searchDictionary(
        query,
        category: _selectedCategory,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load entries by category
  Future<void> loadEntriesByCategory(DictionaryCategory category) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedCategory = category;
      notifyListeners();

      _entries = await _databaseService.getDictionaryByCategory(category);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load favorite entries
  Future<void> loadFavoriteEntries() async {
    try {
      _favoriteEntries = await _databaseService.getFavoriteDictionaryEntries();
      notifyListeners();
    } catch (e) {
      print('Error loading favorite entries: $e');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(DictionaryEntry entry) async {
    try {
      final updatedEntry = entry.copyWith(
        isFavorite: !entry.isFavorite,
      );

      await _databaseService.updateDictionaryEntry(updatedEntry);

      // Update local lists
      _updateLocalLists(entry, updatedEntry);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _updateLocalLists(DictionaryEntry oldEntry, DictionaryEntry newEntry) {
    // Update entries list
    final entriesIndex = _entries.indexWhere((e) => e.id == oldEntry.id);
    if (entriesIndex != -1) {
      _entries[entriesIndex] = newEntry;
    }

    // Update search results
    final searchIndex = _searchResults.indexWhere((e) => e.id == oldEntry.id);
    if (searchIndex != -1) {
      _searchResults[searchIndex] = newEntry;
    }

    // Update favorites list
    if (newEntry.isFavorite) {
      if (!_favoriteEntries.any((e) => e.id == newEntry.id)) {
        _favoriteEntries.insert(0, newEntry);
      }
    } else {
      _favoriteEntries.removeWhere((e) => e.id == oldEntry.id);
    }
  }

  // Set selected category
  void setSelectedCategory(DictionaryCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      if (category != null) {
        loadEntriesByCategory(category);
      } else {
        _entries.clear();
        notifyListeners();
      }
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    notifyListeners();
  }

  // Get entries for specific language
  List<DictionaryEntry> getEntriesForLanguage(Language language) {
    final currentList = _searchQuery.isNotEmpty ? _searchResults : _entries;
    return currentList; // All entries contain all three languages
  }

  // Get categories with entry counts
  Future<Map<DictionaryCategory, int>> getCategoryCounts() async {
    final counts = <DictionaryCategory, int>{};
    
    for (final category in DictionaryCategory.values) {
      try {
        final entries = await _databaseService.getDictionaryByCategory(category);
        counts[category] = entries.length;
      } catch (e) {
        counts[category] = 0;
      }
    }
    
    return counts;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh current view
  Future<void> refresh() async {
    if (_selectedCategory != null) {
      await loadEntriesByCategory(_selectedCategory!);
    }
    await loadFavoriteEntries();
  }
}
