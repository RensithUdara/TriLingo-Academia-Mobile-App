import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dictionary_controller.dart';
import '../models/dictionary_model.dart';
import '../utils/app_theme.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DictionaryController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search dictionary...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            controller.clearSearch();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  controller.searchDictionary(query);
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: controller.selectedCategory == null,
                      onSelected: (selected) {
                        controller.setSelectedCategory(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...DictionaryCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category.displayName),
                          selected: controller.selectedCategory == category,
                          onSelected: (selected) {
                            controller.setSelectedCategory(selected ? category : null);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Results
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.clearError();
                                    controller.refresh();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : _buildDictionaryList(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDictionaryList(DictionaryController controller) {
    final entries = controller.searchQuery.isNotEmpty
        ? controller.searchResults
        : controller.entries;

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.isNotEmpty
                  ? 'No results found for "${controller.searchQuery}"'
                  : 'Select a category to browse dictionary entries',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.getLanguageColor(entry.category.name)
                  .withOpacity(0.2),
              child: Text(
                entry.category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(
              entry.englishTerm,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.sinhalaTerm} | ${entry.tamilTerm}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.definition,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                controller.toggleFavorite(entry);
              },
              icon: Icon(
                entry.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: entry.isFavorite ? AppTheme.errorColor : null,
              ),
            ),
            onTap: () {
              _showEntryDetails(context, entry);
            },
          ),
        );
      },
    );
  }

  void _showEntryDetails(BuildContext context, DictionaryEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(entry.englishTerm),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageRow('English', entry.englishTerm),
                const SizedBox(height: 8),
                _buildLanguageRow('Sinhala', entry.sinhalaTerm),
                const SizedBox(height: 8),
                _buildLanguageRow('Tamil', entry.tamilTerm),
                const SizedBox(height: 16),
                Text(
                  'Definition:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(entry.definition),
                if (entry.pronunciation.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Pronunciation:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(entry.pronunciation),
                ],
                if (entry.examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Examples:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...entry.examples.map((example) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $example'),
                      )),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageRow(String language, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$language:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
