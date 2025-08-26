import 'package:flutter/material.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/utils/theme.dart';

class MushroomDetailPage extends StatelessWidget {
  final Mushroom mushroom;
  final bool fromScanner;

  const MushroomDetailPage({
    super.key, 
    required this.mushroom,
    this.fromScanner = false
  });

  Widget _buildEdibilitySection(String? edibility) {
    IconData icon;
    Color color;
    String edibilityText = edibility ?? 'Unknown edibility';
    String label = '';
    
 if (edibility == 'edible mushroom') {
      icon = Icons.check_circle;
      color = AppTheme.edibleColor;
      label = 'Edible';
    } else if (edibility == 'inedible mushroom') {
      icon = Icons.not_interested;
      color = AppTheme.inedibleColor;
      label = 'Inedible';
    } else if (edibility == 'choice mushroom') {
      icon = Icons.dinner_dining;
      color = AppTheme.choiceColour;
      label = 'Choice';
    } else if (edibility == 'poisonous mushroom') {
      icon = Icons.sick;
      color = AppTheme.poisonousColor;
      label = 'Poisonous';
    } else if (edibility == 'deadly mushroom') {
      icon = Icons.dangerous;
      color = AppTheme.deadlyColour;
      label = 'Deadly';
    } else if (edibility == 'psychoactive mushroom') {
      icon = Icons.psychology;
      color = AppTheme.psychoactiveColor;
      label = 'Psychoactive';
    } else if (edibility == 'caution mushroom') {
      icon = Icons.warning;
      color = AppTheme.warningColor;
      label = 'Not Recommended for Consumption';
    } else if (edibility == 'medicinal mushrooms') {
      icon = Icons.healing  ;
      color = AppTheme.medicinalColor;
      label = 'Medicinal';
    } else {
      icon = Icons.help_outline;
      color = AppTheme.textSecondaryColor;
      label = 'Unknown';
    }
  
    return Card(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
        side: BorderSide(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: AppTheme.iconSizeL),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edibility',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeL,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              edibilityText,
              style: const TextStyle(fontSize: AppTheme.fontSizeM),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxonomySection() {
    // Check if we have any taxonomy information to display
    bool hasTaxonomy = mushroom.phylum != null || 
                       mushroom.mushroomClass != null || 
                       mushroom.order != null || 
                       mushroom.family != null || 
                       mushroom.genus != null;
    
    if (!hasTaxonomy) {
      return const SizedBox.shrink();
    }
    
    return Card(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.science_outlined,
                  color: AppTheme.secondaryColor,
                  size: AppTheme.iconSizeL,
                ),
                SizedBox(width: AppTheme.spacingM),
                Text(
                  'Taxonomy',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Key Taxonomy Information (Class and Genus) - Highlighted 
            if (mushroom.mushroomClass != null || mushroom.genus != null)
              Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                  border: Border.all(color: AppTheme.primaryLightColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (mushroom.mushroomClass != null && mushroom.mushroomClass!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Class:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                mushroom.mushroomClass!,
                                style: const TextStyle(
                                  fontSize: AppTheme.fontSizeM,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (mushroom.genus != null && mushroom.genus!.isNotEmpty)
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Genus:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              mushroom.genus!,
                              style: const TextStyle(
                                fontSize: AppTheme.fontSizeM,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            
            // Full Taxonomy Information
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                border: Border.all(color: AppTheme.textLightColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildTaxonomyRowWithDivider('Scientific Name', mushroom.name, 0),
                  if (mushroom.phylum != null && mushroom.phylum!.isNotEmpty)
                    _buildTaxonomyRowWithDivider('Phylum', mushroom.phylum!, 1),
                  if (mushroom.mushroomClass != null && mushroom.mushroomClass!.isNotEmpty)
                    _buildTaxonomyRowWithDivider('Class', mushroom.mushroomClass!, 2),
                  if (mushroom.order != null && mushroom.order!.isNotEmpty)
                    _buildTaxonomyRowWithDivider('Order', mushroom.order!, 3),
                  if (mushroom.family != null && mushroom.family!.isNotEmpty)
                    _buildTaxonomyRowWithDivider('Family', mushroom.family!, 4),
                  if (mushroom.genus != null && mushroom.genus!.isNotEmpty)
                    _buildTaxonomyRowWithDivider('Genus', mushroom.genus!, 5, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxonomyRowWithDivider(String label, String value, int index, {bool isLast = false}) {
    Color bgColor = index.isEven 
        ? AppTheme.backgroundColor
        : AppTheme.surfaceColor;
        
    return Column(
      children: [
        Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeM,
                    fontStyle: label == 'Scientific Name' || label == 'Genus' ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
      ],
    );
  }

  Widget _buildConfidenceSection() {
    if (mushroom.confidence == null) {
      return const SizedBox.shrink();
    }
    
    final confidencePercentage = (mushroom.confidence! * 100).toStringAsFixed(1);
    final Color confidenceColor = mushroom.confidence! > 0.8 
        ? AppTheme.successColor 
        : (mushroom.confidence! > 0.5 ? AppTheme.warningColor : AppTheme.errorColor);
    
    return Card(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.infoColor,
                  size: AppTheme.iconSizeL,
                ),
                SizedBox(width: AppTheme.spacingM),
                Text(
                  'Identification Confidence',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeL,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$confidencePercentage%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: confidenceColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            LinearProgressIndicator(
              value: mushroom.confidence!,
              backgroundColor: AppTheme.textLightColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(confidenceColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              mushroom.confidence! > 0.7 
                ? 'High confidence identification'
                : (mushroom.confidence! > 0.5 
                    ? 'Moderate confidence identification' 
                    : 'Low confidence identification'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: AppTheme.fontSizeM,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mushroom.name),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Mushroom image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: mushroom.imageUrl.isNotEmpty
                ? Image.network(
                    mushroom.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: AppTheme.textLightColor,
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                  ),
            ),
            
            // Mushroom name
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Text(
                mushroom.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            
            // Confidence section (if available)
            _buildConfidenceSection(),
            
            // Edibility
            _buildEdibilitySection(mushroom.edibility),
            
            // Taxonomy information with emphasized class and genus
            _buildTaxonomySection(),
            
            // Description
            Card(
              margin: const EdgeInsets.all(AppTheme.spacingM),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: AppTheme.primaryColor,
                          size: AppTheme.iconSizeL,
                        ),
                        SizedBox(width: AppTheme.spacingM),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeL,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppTheme.spacingM),
                    Text(
                      'No description yet.', //until proper descriptions implemented
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeM,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingM),
          ],
        ),
      ),
    );
  }
}