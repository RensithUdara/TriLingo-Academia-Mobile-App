import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/translation_controller.dart';
import '../controllers/audio_controller.dart';
import '../models/translation_model.dart';
import '../utils/app_theme.dart';
import '../widgets/language_selector.dart';
import '../widgets/translation_card.dart';
import '../widgets/input_field.dart';

class TranslationView extends StatefulWidget {
  const TranslationView({super.key});

  @override
  State<TranslationView> createState() => _TranslationViewState();
}

class _TranslationViewState extends State<TranslationView> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  Translation? _currentTranslation;

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TranslationController, AudioController>(
      builder: (context, translationController, audioController, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Language Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LanguageSelector(
                          selectedLanguage: translationController.sourceLanguage,
                          onLanguageChanged: (language) {
                            translationController.setSourceLanguage(language);
                          },
                          label: 'From',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          translationController.swapLanguages();
                          // Swap the text if there's a current translation
                          if (_currentTranslation != null) {
                            _inputController.text = _currentTranslation!.translatedText;
                            translationController.setInput(_currentTranslation!.translatedText);
                          }
                        },
                        icon: const Icon(Icons.swap_horiz, size: 28),
                        color: AppTheme.primaryColor,
                      ),
                      Expanded(
                        child: LanguageSelector(
                          selectedLanguage: translationController.targetLanguage,
                          onLanguageChanged: (language) {
                            translationController.setTargetLanguage(language);
                          },
                          label: 'To',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Input Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter text to translate',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        controller: _inputController,
                        focusNode: _inputFocusNode,
                        hintText: 'Type or speak to translate...',
                        maxLines: 3,
                        onChanged: (text) {
                          translationController.setInput(text);
                        },
                        onSubmitted: (text) {
                          _performTranslation();
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Voice input button
                          IconButton(
                            onPressed: audioController.isListening
                                ? () async {
                                    await audioController.stopListening();
                                  }
                                : () async {
                                    await audioController.startListening(
                                      language: translationController.sourceLanguage,
                                    );
                                  },
                            icon: Icon(
                              audioController.isListening 
                                  ? Icons.mic_off 
                                  : Icons.mic,
                            ),
                            color: audioController.isListening 
                                ? AppTheme.errorColor 
                                : AppTheme.primaryColor,
                            tooltip: audioController.isListening 
                                ? 'Stop listening' 
                                : 'Voice input',
                          ),
                          
                          // Clear button
                          IconButton(
                            onPressed: () {
                              _inputController.clear();
                              translationController.clearInput();
                              setState(() {
                                _currentTranslation = null;
                              });
                            },
                            icon: const Icon(Icons.clear),
                            tooltip: 'Clear',
                          ),
                          
                          const Spacer(),
                          
                          // Translate button
                          ElevatedButton.icon(
                            onPressed: translationController.isLoading
                                ? null
                                : _performTranslation,
                            icon: translationController.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.translate),
                            label: Text(
                              translationController.isLoading
                                  ? 'Translating...'
                                  : 'Translate',
                            ),
                          ),
                        ],
                      ),

                      // Suggestions
                      if (translationController.suggestions.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Suggestions:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: translationController.suggestions
                              .map((suggestion) => GestureDetector(
                                    onTap: () {
                                      _inputController.text = suggestion;
                                      translationController.setInput(suggestion);
                                      _performTranslation();
                                    },
                                    child: Chip(
                                      label: Text(
                                        suggestion,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Translation Result
              if (_currentTranslation != null)
                TranslationCard(
                  translation: _currentTranslation!,
                  onFavoriteToggle: () {
                    translationController.toggleFavorite(_currentTranslation!);
                    setState(() {
                      _currentTranslation = _currentTranslation!.copyWith(
                        isFavorite: !_currentTranslation!.isFavorite,
                      );
                    });
                  },
                  onSpeak: (text, language) async {
                    await audioController.speak(text, language);
                  },
                ),

              // Error display
              if (translationController.error != null)
                Card(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.errorColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            translationController.error!,
                            style: TextStyle(
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            translationController.clearError();
                          },
                          icon: const Icon(Icons.close),
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Recent Translations
              if (translationController.translations.isNotEmpty)
                Expanded(
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Recent Translations',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: translationController.translations.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final translation = translationController.translations[index];
                              return ListTile(
                                title: Text(
                                  translation.sourceText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  translation.translatedText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.getLanguageColor(
                                      translation.targetLanguage.name,
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (translation.isFavorite)
                                      Icon(
                                        Icons.favorite,
                                        color: AppTheme.errorColor,
                                        size: 16,
                                      ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () async {
                                        await audioController.speak(
                                          translation.translatedText,
                                          translation.targetLanguage,
                                        );
                                      },
                                      icon: const Icon(Icons.volume_up),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _currentTranslation = translation;
                                    _inputController.text = translation.sourceText;
                                    translationController.setInput(translation.sourceText);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _performTranslation() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final translationController = context.read<TranslationController>();
    final result = await translationController.translateText(text);
    
    if (result != null) {
      setState(() {
        _currentTranslation = result;
      });
    }
  }
}
