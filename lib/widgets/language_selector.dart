import 'package:flutter/material.dart';
import '../models/translation_model.dart';
import '../utils/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final Language selectedLanguage;
  final Function(Language) onLanguageChanged;
  final String label;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.getLanguageColor(selectedLanguage.name).withOpacity(0.1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Language>(
              value: selectedLanguage,
              isDense: true,
              onChanged: (Language? newValue) {
                if (newValue != null) {
                  onLanguageChanged(newValue);
                }
              },
              items: Language.values.map<DropdownMenuItem<Language>>((Language value) {
                return DropdownMenuItem<Language>(
                  value: value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.getLanguageColor(value.name),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        value.displayName,
                        style: TextStyle(
                          color: AppColors.getLanguageColor(value.name),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
