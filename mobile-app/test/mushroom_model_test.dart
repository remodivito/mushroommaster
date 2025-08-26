import 'package:flutter_test/flutter_test.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';

void main() {
  group('Mushroom Model', () {
    test('Mushroom can be instantiated with correct values', () {
      final mushroom = Mushroom(
        id: '42',
        name: 'Coprinus comatus',
        edibility: 'edible',
        imageUrl: 'shaggy_ink_cap.png',
        description: 'Shaggy Ink Cap',
        confidence: 0.99,
      );

      expect(mushroom.id, equals('42'));
      expect(mushroom.name, equals('Coprinus comatus'));
      expect(mushroom.edibility, equals('edible'));
      expect(mushroom.imageUrl, equals('shaggy_ink_cap.png'));
      expect(mushroom.description, equals('Shaggy Ink Cap'));
      expect(mushroom.confidence, equals(0.99));
    });
  });
}