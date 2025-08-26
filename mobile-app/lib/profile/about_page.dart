import 'package:flutter/material.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/utils/theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
      ),
      bottomNavigationBar: const NavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Taxonomy data in this app is based on information from the Global Biodiversity Information Facility (GBIF), used under the CC BY 4.0 license.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
                        const SizedBox(height: AppTheme.spacingS),
             Text(
              'Source:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'https://gbif.org',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Data were accessed via the GBIF API and modified for integration into Mushroom Master.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'Images from the Danish Fungi 2020 dataset were used in training. Dataset and images provided by MycoKey, University of Copenhagen, and the Danish National History Museum.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Source:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'L. Picek, M. Šulc, T.S. Jeppesen, et al., “Danish Fungi 2020 – Not Just Another Image Recognition Dataset,” WACV 2022.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'DOI: 10.48550/arXiv.2103.10107',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'Additionally, Some training images were sourced from the Mushroom Observer Machine Learning Dataset, and are licensed under Creative Commons. Many thanks to the original image authors - they are individually credited in CREDITS.md.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingS),
             Text(
              'Source:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'https://mushroomobserver.org/articles/20',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
