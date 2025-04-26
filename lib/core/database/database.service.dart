import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _db;

  Future<void> init() async {
    if (_db != null) return; // Already initialized

    _db = await openDatabase(
      'myapp.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE loyalty_cards(id TEXT PRIMARY KEY, name TEXT, barcode TEXT, color NUMBER, usageCount INTEGER)',
        );
        await db.execute(
          'CREATE TABLE shopping_items (id TEXT PRIMARY KEY, productName TEXT)',
        );
      },
    );
  }

  Database get database {
    if (_db == null) {
      throw Exception('Database is not initialized!');
    }
    return _db!;
  }

  // Other methods like insert/update/delete...
}
