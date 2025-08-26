import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDbHelper {
  static final HistoryDbHelper _instance = HistoryDbHelper._internal();
  static Database? _database;

  factory HistoryDbHelper() => _instance;

  HistoryDbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mushroom_history.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE mushroom_history(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mushroom_id TEXT NOT NULL,
      name TEXT NOT NULL,
      species_name TEXT,
      edibility TEXT,
      image_url TEXT NOT NULL,
      description TEXT NOT NULL,
      confidence REAL,
      image_path TEXT NOT NULL,
      date_identified TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertIdentification(Mushroom mushroom, String imagePath) async {
    final db = await database;
    
    final Map<String, dynamic> data = {
      'mushroom_id': mushroom.id,
      'name': mushroom.name,
      'edibility': mushroom.edibility,
      'image_url': mushroom.imageUrl,
      'description': mushroom.description,
      'confidence': mushroom.confidence,
      'image_path': imagePath,
      'date_identified': DateTime.now().toIso8601String()
    };
    
    return await db.insert('mushroom_history', data);
  }

  Future<List<Map<String, dynamic>>> getIdentificationHistory() async {
    final db = await database;
    return await db.query('mushroom_history', orderBy: 'date_identified DESC');
  }

  Future<Mushroom> mushroomFromHistoryEntry(Map<String, dynamic> entry) async {
    return Mushroom(
      id: entry['mushroom_id'],
      name: entry['name'],
      edibility: entry['edibility'],
      imageUrl: entry['image_url'],
      description: entry['description'],
      confidence: entry['confidence'],
    );
  }

  Future<void> deleteIdentification(int id) async {
    final db = await database;
    await db.delete('mushroom_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('mushroom_history');
  }
} 