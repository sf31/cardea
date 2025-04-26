import 'package:sqflite/sqflite.dart';

abstract class GenericRepository<T> {
  final Database db;
  final String tableName;

  GenericRepository(this.db, this.tableName);

  T fromMap(Map<String, dynamic> map);

  Map<String, Object?> toMap(T entity);

  String getId(T item);

  Future<List<T>> getAll() async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    // return maps.map(m => fromMap(m)).toList();
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<T?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<void> create(T entity) async {
    await db.insert(
      tableName,
      toMap(entity),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(T entity) async {
    await db.update(
      tableName,
      toMap(entity),
      where: 'id = ?',
      whereArgs: [getId(entity)],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
