import 'package:sqflite/sqflite.dart';

const _LOYALTY_CARDS_TABLE = 'loyalty_cards';
const _SHOPPING_ITEMS_TABLE = 'shopping_items';

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
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Database get database {
    if (_db == null) {
      throw Exception('Database is not initialized!');
    }
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $_LOYALTY_CARDS_TABLE (id TEXT PRIMARY KEY, name TEXT, barcode TEXT, color NUMBER, usage_count INTEGER, updated_at INTEGER)',
    );
    await db.execute(
      'CREATE TABLE $_SHOPPING_ITEMS_TABLE (id TEXT PRIMARY KEY, name TEXT, updated_at INTEGER, completed_at INTEGER)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 2) {
    //   await db.execute(
    //     '''ALTER TABLE $_SHOPPING_ITEMS_TABLE ADD COLUMN completed_at INTEGER''',
    //   );
    //   await db.execute(
    //     ''' UPDATE $_SHOPPING_ITEMS_TABLE SET completed_at = NULL WHERE completed_at IS NULL''',
    //   );
    // }

    // Future: if (oldVersion < 3) { migrate more... }
  }
}
