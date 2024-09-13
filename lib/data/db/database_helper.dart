import 'package:savor/data/model/restaurant.dart';
import 'package:savor/state/database/database_bloc.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database? _db;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _db = await _initDb();
    return _db!;
  }

  static const String _tableName = 'fav_restaurant';

  Future<Database> _initDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/savor.db',
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
              id TEXT PRIMARY KEY,
              name TEXT,
              description TEXT,
              pictureId TEXT,
              city TEXT,
              rating REAL
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<String> insertBookmark(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableName, restaurant.toJson());
    return "Bookmark added";
  }

  Future<List<Restaurant>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<bool> isBookmarked(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> removeBookmark(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return "Bookmark removed";
  }
}
