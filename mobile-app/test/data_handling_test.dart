import 'package:flutter_test/flutter_test.dart';
import 'package:mushroom_master/utils/history_db_helper.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Loads mushroom entry from local database', () async {
    final dbHelper = HistoryDbHelper();
    // Insert a mock mushroom
    final mushroom = Mushroom(
      id: '1',
      name: 'Amanita muscaria',
      edibility: 'poisonous',
      imageUrl: 'test.png',
      description: 'No description yet.',
      confidence: 0.95,
    );
    await dbHelper.insertIdentification(mushroom, 'test_path');
    final history = await dbHelper.getIdentificationHistory();
    expect(history.first['name'], equals('Amanita muscaria'));
    expect(history.first['edibility'], equals('poisonous'));
    expect(history.first['confidence'], equals(0.95));
    expect(history.first['image_url'], equals('test.png'));
    expect(history.first['description'], equals('No description yet.'));
  });
}