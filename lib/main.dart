import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/translation_controller.dart';
import 'controllers/dictionary_controller.dart';
import 'controllers/audio_controller.dart';
import 'controllers/settings_controller.dart';
import 'views/home_view.dart';
import 'services/database_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.instance.initDatabase();
  
  runApp(const TriLingoApp());
}

class TriLingoApp extends StatelessWidget {
  const TriLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationController()),
        ChangeNotifierProvider(create: (_) => DictionaryController()),
        ChangeNotifierProvider(create: (_) => AudioController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settingsController, child) {
          return MaterialApp(
            title: 'TriLingo Translator Plus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsController.isDarkMode 
                ? ThemeMode.dark 
                : ThemeMode.light,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}
