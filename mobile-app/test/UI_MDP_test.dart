import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/guide/view/mushroom_detail_page.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:mushroom_master/navigation/cubit/nav_bar_cubit.dart';

void main() {
  testWidgets('MushroomDetailPage displays correct mushroom info', (WidgetTester tester) async {
    final mushroom = Mushroom(
      id: '1',
      name: 'Amanita muscaria',
      edibility: 'poisonous',
      imageUrl: 'test.png',
      description: 'Fly agaric',
      confidence: 0.92,
    );
    await tester.pumpWidget(
      BlocProvider<NavBarCubit>(
        create: (_) => NavBarCubit(),
        child: MaterialApp(
          home: MushroomDetailPage(mushroom: mushroom),
        ),
      ),
    );
    expect(find.text('Amanita muscaria'), findsWidgets); // verify the app shows the mushrooms name
    expect(find.text('High confidence identification'), findsOneWidget); // verify the mushroom is identified with high confidence
    expect(find.text('No description yet.'), findsOneWidget); // hardcoded for now - verify the description is overridden by placeholder

  });
}