import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/translation_controller.dart';
import '../controllers/dictionary_controller.dart';
import '../controllers/audio_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/app_theme.dart';
import 'translation_view.dart';
import 'dictionary_view.dart';
import 'flashcards_view.dart';
import 'settings_view.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() async {
    final translationController = context.read<TranslationController>();
    final dictionaryController = context.read<DictionaryController>();
    final audioController = context.read<AudioController>();
    final settingsController = context.read<SettingsController>();

    await Future.wait([
      translationController.initialize(),
      dictionaryController.initialize(),
      audioController.initialize(),
      settingsController.initialize(),
    ]);
  }

  final List<Widget> _pages = [
    const TranslationView(),
    const DictionaryView(),
    const FlashcardsView(),
    const SettingsView(),
  ];

  final List<String> _titles = [
    'Translator',
    'Dictionary',
    'Flashcards',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_currentIndex == 0) // Translation view
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                // Navigate to translation history
              },
            ),
          if (_currentIndex == 1) // Dictionary view
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                // Navigate to favorite words
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
