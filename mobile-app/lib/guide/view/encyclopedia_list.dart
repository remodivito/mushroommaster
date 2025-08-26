import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/guide/bloc/encyclopedia_bloc.dart';
import 'package:mushroom_master/guide/view/mushroom_detail_page.dart';
import 'package:mushroom_master/guide/widgets/bottom_loader.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:mushroom_master/utils/theme.dart';

class EncyclopediaList extends StatefulWidget {
  const EncyclopediaList({super.key});

  @override
  State<EncyclopediaList> createState() => _EncyclopediaListState();
}

class _EncyclopediaListState extends State<EncyclopediaList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncyclopediaBloc, EncyclopediaState>(
      builder: (context, state) {
        switch (state.status) {
          case EntryStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  const Text('Failed to fetch mushrooms'),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EncyclopediaBloc>().add(EntryFetched());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          case EntryStatus.success:
            if (state.entries.isEmpty) {
              return const Center(
                child: Text('No mushrooms available'),
              );
            }

            // Sort entries to prioritize mushrooms with defined edibility
            final sortedEntries = List<Mushroom>.from(state.entries);
            sortedEntries.sort((a, b) {
              // Helper function to check if edibility is unknown
              bool isUnknown(String? value) {
                if (value == null) return true;
                final normalized = value.trim().toLowerCase();
                return normalized.isEmpty || 
                       normalized == 'unknown' || 
                       normalized == 'null' || 
                       normalized == 'undefined';
              }

              // Assign a numeric value for sorting: 0 for known edibility, 1 for unknown
              final aValue = isUnknown(a.edibility) ? 1 : 0;
              final bValue = isUnknown(b.edibility) ? 1 : 0;
              
              // Simple numeric comparison will ensure all known edibility mushrooms 
              // appear before unknown ones
              return aValue.compareTo(bValue);
            });

            return Padding(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= sortedEntries.length
                      ? const BottomLoader()
                      : EncyclopediaListItem(entry: sortedEntries[index]);
                },
                itemCount: state.hasReachedMax
                    ? sortedEntries.length
                    : sortedEntries.length + 1,
                controller: _scrollController,
              ),
            );
          case EntryStatus.initial:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<EncyclopediaBloc>().add(EntryFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class EncyclopediaListItem extends StatelessWidget {
  final Mushroom entry;

  const EncyclopediaListItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppTheme.spacingS,
        horizontal: AppTheme.spacingS,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MushroomDetailPage(mushroom: entry),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mushroom image with edibility badge
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: entry.imageUrl.isNotEmpty
                      ? Image.network(
                          entry.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.eco,
                            size: 40,
                          ),
                        ),
                ),
                // Edibility badge
                if (entry.edibility != null)
                  Positioned(
                    top: AppTheme.spacingS,
                    right: AppTheme.spacingS,
                    child: _buildEdibilityBadge(entry.edibility!),
                  ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    entry.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
                    child: Text(
                      entry.name,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: AppTheme.fontSizeS,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                  
                  // Class instead of description
                  if (entry.mushroomClass != null && entry.mushroomClass!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.science_outlined,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Class: ${entry.mushroomClass!}',
                            style: const TextStyle(
                              fontSize: AppTheme.fontSizeS,
                              color: AppTheme.textSecondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    // If no class available, show description as fallback
                    Text(
                      entry.description.isNotEmpty ? entry.description : 'No description available',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEdibilityBadge(String edibility) {
    IconData icon;
    Color color;
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
    } else if (edibility == 'edible when cooked') {
      icon = Icons.restaurant;
      color = AppTheme.edibleWithCautionColor;
      label = 'Edible When Cooked';
    } else if (edibility == 'psychoactive mushroom') {
      icon = Icons.psychology;
      color = AppTheme.psychoactiveColor;
      label = 'Psychoactive';
    } else if (edibility == 'caution mushroom') {
      icon = Icons.warning;
      color = AppTheme.warningColor;
      label = 'Not Recommended for Consumption';
    } else if (edibility == 'medicinal mushrooms') {
      icon = Icons.healing;
      color = AppTheme.medicinalColor;
      label = 'Medicinal';
    } else {
      icon = Icons.help_outline;
      color = AppTheme.textSecondaryColor;
      label = 'Unknown';
    }
  
    return Tooltip(
      message: edibility,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS,
          vertical: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
