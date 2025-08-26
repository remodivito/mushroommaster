import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mushroom_master/guide/view/mushroom_detail_page.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/utils/history_db_helper.dart';
import 'package:mushroom_master/utils/theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryDbHelper _dbHelper = HistoryDbHelper();
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    final history = await _dbHelper.getIdentificationHistory();

    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  Future<void> _deleteHistoryItem(int id) async {
    await _dbHelper.deleteIdentification(id);
    _loadHistory();
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all identification history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification History'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllHistory,
              tooltip: 'Clear all history',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        'No identification history',
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeL,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Scan mushrooms to build your history',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final dateIdentified = DateTime.parse(item['date_identified']);
                    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(dateIdentified);
                    final confidence = item['confidence'] ?? 0.0;
                    final confidencePercentage = (confidence * 100).toStringAsFixed(1);
                    
                    return Dismissible(
                      key: Key(item['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppTheme.spacingL),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) => _deleteHistoryItem(item['id']),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final mushroom = await _dbHelper.mushroomFromHistoryEntry(item);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MushroomDetailPage(
                                    mushroom: mushroom,
                                    fromScanner: true,
                                  ),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: AppTheme.fontSizeS,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      '$confidencePercentage% match',
                                      style: TextStyle(
                                        fontSize: AppTheme.fontSizeS,
                                        fontWeight: FontWeight.bold,
                                        color: _getConfidenceColor(confidence),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                // Content row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Mushroom image from local file
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: _buildImage(item['image_path']),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    // Mushroom information
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: AppTheme.fontSizeM,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item['species_name'] != null)
                                            Text(
                                              item['species_name'],
                                              style: TextStyle(
                                                fontSize: AppTheme.fontSizeS,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          const SizedBox(height: AppTheme.spacingS),
                                          if (item['edibility'] != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: AppTheme.spacingS,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getEdibilityColor(item['edibility']),
                                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusS),
                                              ),
                                              child: Text(
                                                item['edibility'],
                                                style: const TextStyle(
                                                  fontSize: AppTheme.fontSizeXS,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, color: Colors.grey),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget _buildImage(String imagePath) {
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        ),
      );
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.7) {
      return Colors.green;
    } else if (confidence >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getEdibilityColor(String edibility) {
    switch (edibility.toLowerCase()) {
      case 'edible':
        return Colors.green;
      case 'poisonous':
        return Colors.red;
      case 'inedible':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 