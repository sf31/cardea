import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _db;

  Future<void> init() async {
    if (_db != null) return;

    _db = await openDatabase(
      'myapp.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE loyalty_cards(id TEXT PRIMARY KEY, name TEXT, barcode TEXT, color NUMBER, usageCount INTEGER)',
        );
        await db.execute(
          'CREATE TABLE shopping_items (id TEXT PRIMARY KEY, name TEXT)',
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        '''ALTER TABLE loyalty_cards ADD COLUMN updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)''',
      );
      await db.execute(
        '''ALTER TABLE shopping_items ADD COLUMN updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)''',
      );
    }

    // Future: if (oldVersion < 3) { migrate more... }
  }
}
