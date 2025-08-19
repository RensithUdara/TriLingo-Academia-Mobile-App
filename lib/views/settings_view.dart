import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import '../models/translation_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Use dark theme'),
                      value: controller.isDarkMode,
                      onChanged: (value) {
                        controller.toggleDarkMode();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Language Settings
              _buildSectionHeader(context, 'Default Languages'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Default Source Language'),
                      subtitle: Text(controller.defaultSourceLanguage.displayName),
                      trailing: DropdownButton<Language>(
                        value: controller.defaultSourceLanguage,
                        onChanged: (Language? newValue) {
                          if (newValue != null) {
                            controller.setDefaultSourceLanguage(newValue);
                          }
                        },
                        items: Language.values.map((Language language) {
                          return DropdownMenuItem<Language>(
                            value: language,
                            child: Text(language.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Default Target Language'),
                      subtitle: Text(controller.defaultTargetLanguage.displayName),
                      trailing: DropdownButton<Language>(
                        value: controller.defaultTargetLanguage,
                        onChanged: (Language? newValue) {
                          if (newValue != null) {
                            controller.setDefaultTargetLanguage(newValue);
                          }
                        },
                        items: Language.values.map((Language language) {
                          return DropdownMenuItem<Language>(
                            value: language,
                            child: Text(language.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Audio Settings
              _buildSectionHeader(context, 'Audio Settings'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Speech Rate'),
                      subtitle: Slider(
                        value: controller.speechRate,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        label: '${(controller.speechRate * 100).round()}%',
                        onChanged: (value) {
                          controller.setSpeechRate(value);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Volume'),
                      subtitle: Slider(
                        value: controller.volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${(controller.volume * 100).round()}%',
                        onChanged: (value) {
                          controller.setVolume(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Translation Settings
              _buildSectionHeader(context, 'Translation Settings'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Auto Translate'),
                      subtitle: const Text('Automatically translate when typing'),
                      value: controller.autoTranslate,
                      onChanged: (value) {
                        controller.toggleAutoTranslate();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Show Pronunciation'),
                      subtitle: const Text('Display pronunciation guides'),
                      value: controller.showPronunciation,
                      onChanged: (value) {
                        controller.toggleShowPronunciation();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Offline Mode'),
                      subtitle: const Text('Use only offline translations'),
                      value: controller.offlineMode,
                      onChanged: (value) {
                        controller.toggleOfflineMode();
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Data Management
              _buildSectionHeader(context, 'Data Management'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Export Data'),
                      subtitle: const Text('Export your translations and settings'),
                      onTap: () async {
                        await controller.exportUserData();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data exported successfully'),
                            ),
                          );
                        }
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.upload),
                      title: const Text('Import Data'),
                      subtitle: const Text('Import previously exported data'),
                      onTap: () {
                        // Implement import functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Import feature coming soon'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.refresh, color: Colors.orange),
                      title: const Text('Reset Settings'),
                      subtitle: const Text('Reset all settings to default'),
                      onTap: () {
                        _showResetDialog(context, controller);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // About Section
              _buildSectionHeader(context, 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('App Version'),
                      subtitle: Text('${controller.getAppInfo()['version']}+${controller.getAppInfo()['buildNumber']}'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Developer'),
                      subtitle: Text(controller.getAppInfo()['developer']),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('About'),
                      subtitle: Text(controller.getAppInfo()['description']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.resetToDefaults();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
