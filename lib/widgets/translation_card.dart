import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/translation_model.dart';
import '../utils/app_theme.dart';

class TranslationCard extends StatelessWidget {
  final Translation translation;
  final VoidCallback onFavoriteToggle;
  final Function(String, Language) onSpeak;

  const TranslationCard({
    super.key,
    required this.translation,
    required this.onFavoriteToggle,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source text
            _buildTextSection(
              context,
              'Source (${translation.sourceLanguage.displayName})',
              translation.sourceText,
              translation.sourceLanguage,
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Translated text
            _buildTextSection(
              context,
              'Translation (${translation.targetLanguage.displayName})',
              translation.translatedText,
              translation.targetLanguage,
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                // Copy source button
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: translation.sourceText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Source text copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy source text',
                ),
                
                // Copy translation button
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: translation.translatedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Translation copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.content_copy),
                  tooltip: 'Copy translation',
                ),
                
                // Speak source button
                IconButton(
                  onPressed: () => onSpeak(translation.sourceText, translation.sourceLanguage),
                  icon: const Icon(Icons.volume_up),
                  tooltip: 'Speak source text',
                ),
                
                // Speak translation button
                IconButton(
                  onPressed: () => onSpeak(translation.translatedText, translation.targetLanguage),
                  icon: const Icon(Icons.record_voice_over),
                  tooltip: 'Speak translation',
                ),
                
                const Spacer(),
                
                // Favorite button
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    translation.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: translation.isFavorite ? AppTheme.errorColor : null,
                  ),
                  tooltip: translation.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                ),
              ],
            ),
            
            // Timestamp
            const SizedBox(height: 8),
            Text(
              'Translated ${_formatDateTime(translation.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(
    BuildContext context,
    String title,
    String text,
    Language language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.getLanguageColor(language.name),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.getLanguageColor(language.name),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.getLanguageColor(language.name).withOpacity(0.05),
            border: Border.all(
              color: AppColors.getLanguageColor(language.name).withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
