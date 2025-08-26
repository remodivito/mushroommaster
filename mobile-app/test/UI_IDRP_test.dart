import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/navigation/cubit/nav_bar_cubit.dart'; // [`NavBarCubit`](lib/navigation/cubit/nav_bar_cubit.dart)
import 'package:mushroom_master/guide/widgets/mushroom.dart'; // [`Mushroom`](lib/guide/widgets/mushroom.dart)
import 'package:mushroom_master/scanner/identification_results_page.dart'; // [`IdentificationResultsPage`](lib/scanner/identification_results_page.dart)

void main() {
  testWidgets('IdentificationResultsPage shows top matches', (WidgetTester tester) async {
    final testMushrooms = [
      const Mushroom(
        id: '1',
        name: 'Amanita muscaria',
        edibility: 'poisonous',
        imageUrl: 'test.png',
        description: 'Fly agaric',
        confidence: 0.95,
      ),
      const Mushroom(
        id: '2',
        name: 'Boletus edulis',
        edibility: 'edible mushroom',
        imageUrl: 'test2.png',
        description: 'Porcini',
        confidence: 0.85,
      ),
    ];

    await tester.pumpWidget(
      BlocProvider<NavBarCubit>(
        create: (_) => NavBarCubit(),
        child: MaterialApp(
          home: IdentificationResultsPage(
            mushrooms: testMushrooms,
            imagePath: 'test_path.jpg',
          ),
        ),
      ),
    );

    // Matches the two Text widgets for each mushroom name
    expect(find.text('Amanita muscaria'), findsNWidgets(2));
    expect(find.text('Boletus edulis'), findsNWidgets(2));
    expect(find.text('Top Matches'), findsOneWidget);
    expect(find.text('95.0%'), findsOneWidget);
    expect(find.text('85.0%'), findsOneWidget);
  });
}