import 'package:flutter/material.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:mushroom_master/guide/view/mushroom_detail_page.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/utils/history_db_helper.dart';
import 'package:mushroom_master/utils/theme.dart';
import 'dart:io';

class IdentificationResultsPage extends StatelessWidget {
  final List<Mushroom> mushrooms;
  final String imagePath;

  const IdentificationResultsPage({
    Key? key,
    required this.mushrooms,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display the captured/selected image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Results header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            child: const Text(
              'Top Matches',
              style: TextStyle(
                fontSize: AppTheme.fontSizeL,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          // Top 5 mushroom results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              itemCount: mushrooms.length,
              itemBuilder: (context, index) {
                final mushroom = mushrooms[index];
                final confidence = mushroom.confidence ?? 0.0;
                final confidencePercentage = (confidence * 100).toStringAsFixed(1);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                  ),
                  child: InkWell(
                    onTap: () async {
                      // Save to SQLite history database
                      final dbHelper = HistoryDbHelper();
                      await dbHelper.insertIdentification(mushroom, imagePath);
                      
                      // Navigate to the detail page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MushroomDetailPage(
                            mushroom: mushroom,
                            fromScanner: true,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Row(
                        children: [
                          // Mushroom image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusS),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                mushroom.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.withOpacity(0.2),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          // Mushroom information
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mushroom.name,
                                  style: const TextStyle(
                                    fontSize: AppTheme.fontSizeM,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2, // Allow wrapping if name is long
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                // Confidence indicator
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusS),
                                        child: LinearProgressIndicator(
                                          value: confidence,
                                          backgroundColor: Colors.grey.withOpacity(0.2),
                                          color: AppTheme.getConfidenceColor(confidence), // Use AppTheme method
                                          minHeight: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingS),
                                    Text(
                                      '$confidencePercentage%',
                                      style: const TextStyle(
                                        fontSize: AppTheme.fontSizeS,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}