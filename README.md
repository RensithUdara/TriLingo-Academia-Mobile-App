# TriLingo Translator Plus - Academic Language Helper

A comprehensive offline-capable Flutter translation app specifically designed for Sri Lankan students who need to work across Sinhala, Tamil, and English languages. The app includes academic terminology dictionaries, pronunciation guides, text-to-speech in all three languages, and specialized vocabularies for different subjects like medicine, engineering, and law.

## Features

### 🌐 Core Translation
- **Multi-directional translation** between Sinhala, Tamil, and English
- **Offline capability** with downloadable language packs
- **Smart context detection** for academic vs. casual contexts
- **Voice translation** - speak in one language, get translation in another
- **Photo text translation** using camera OCR
- **Batch translation** for multiple words/sentences

### 📚 Academic Dictionaries
- **Medicine Dictionary**: Anatomy, pharmaceutical terms, clinical procedures
- **Engineering Dictionary**: Technical terms, mathematical concepts, project terminology
- **Law Dictionary**: Legal terminology, court procedures, constitutional terms
- **General Dictionary**: Common phrases and everyday vocabulary

### 🔊 Audio & Pronunciation
- **Text-to-Speech (TTS)** in all three languages with offline capability
- **Voice Recognition** for hands-free translation
- **Pronunciation Guide** with phonetic spelling
- **Adjustable speech rate and pitch**

### 📖 Learning Features
- **Flashcard System** with spaced repetition algorithm
- **Progress Tracking** for vocabulary learning
- **Quiz & Assessment Tools** with performance analytics
- **Academic Phrase Builder** for formal writing

## Technology Stack

- **Framework**: Flutter 3.5.3+
- **Architecture**: MVC (Model-View-Controller)
- **State Management**: Provider
- **Database**: SQLite with sqflite
- **Audio**: flutter_tts, speech_to_text
- **UI**: Material Design 3 with custom theming
- **Fonts**: Google Fonts (Poppins, Noto Sans Tamil, Noto Serif Sinhala)

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── controllers/                 # Business logic controllers
│   ├── translation_controller.dart
│   ├── dictionary_controller.dart
│   ├── audio_controller.dart
│   └── settings_controller.dart
├── models/                      # Data models
│   ├── translation_model.dart
│   ├── dictionary_model.dart
│   └── flashcard_model.dart
├── services/                    # Business services
│   ├── database_service.dart
│   ├── translation_service.dart
│   └── audio_service.dart
├── views/                       # UI screens
│   ├── home_view.dart
│   ├── translation_view.dart
│   ├── dictionary_view.dart
│   ├── flashcards_view.dart
│   └── settings_view.dart
├── widgets/                     # Reusable UI components
│   ├── custom_bottom_nav_bar.dart
│   ├── language_selector.dart
│   ├── translation_card.dart
│   └── input_field.dart
└── utils/                       # Utility classes
    └── app_theme.dart
```

## Getting Started

### Prerequisites
- Flutter SDK 3.5.3 or higher
- Dart SDK 3.0+
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/RensithUdara/TriLingo-Academia-Mobile-App.git
   cd TriLingo-Academia-Mobile-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## Features in Detail

### Translation Engine
- **Offline Translation**: Core vocabulary and phrases work without internet
- **Language Detection**: Automatically detects input language
- **Context-Aware**: Understands academic vs. casual contexts
- **History Management**: Saves and manages translation history

### Dictionary Categories
- **Medicine**: 🏥 Medical terms, procedures, anatomy
- **Engineering**: ⚙️ Technical specifications, algorithms
- **Law**: ⚖️ Legal documents, court procedures
- **General**: 📚 Common vocabulary and phrases

### Audio Features
- **Multi-language TTS**: Native speaker quality audio
- **Speech Recognition**: Voice input in all three languages
- **Pronunciation Guide**: Phonetic breakdowns for complex words
- **Audio Controls**: Speed, pitch, and volume adjustment

### Learning System
- **Spaced Repetition**: Scientifically-backed learning algorithm
- **Progress Analytics**: Track learning progress and weak areas
- **Custom Flashcards**: Create personalized study sets
- **Achievement System**: Gamification for motivation

## Configuration

### Language Settings
- Default source and target languages
- Audio preferences (speech rate, volume)
- Offline mode toggle

### Theme Options
- Light and dark mode support
- Language-specific color coding
- Accessible design with high contrast options

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Submit a pull request with a clear description

## Academic Use Cases

### For Medical Students
- Translate complex medical terminology
- Learn anatomy terms in all three languages
- Practice pronunciation of pharmaceutical names
- Study with medical flashcards

### For Engineering Students
- Understand technical specifications
- Learn mathematical terms and concepts
- Practice with engineering vocabulary
- Access offline technical dictionaries

### For Law Students
- Master legal terminology
- Understand court procedures
- Learn constitutional terms
- Practice legal writing in multiple languages

## Roadmap

- [ ] Advanced OCR for handwritten text
- [ ] Collaborative study groups
- [ ] AI-powered translation improvements
- [ ] Integration with academic databases
- [ ] Voice conversation mode
- [ ] Augmented reality translation
- [ ] University-specific terminology packs

## Support

- 📧 Email: support@trilingo.app
- 🐛 Issues: [GitHub Issues](https://github.com/RensithUdara/TriLingo-Academia-Mobile-App/issues)
- 📖 Documentation: [Wiki](https://github.com/RensithUdara/TriLingo-Academia-Mobile-App/wiki)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Google Fonts for multilingual typography
- Flutter community for excellent packages
- Sri Lankan academic institutions for terminology guidance
- Open source contributors and testers

---

**Made with ❤️ for Sri Lankan students by the Rensith Udara**
