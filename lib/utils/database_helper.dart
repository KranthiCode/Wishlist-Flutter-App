import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/wish.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String wishTable = 'wish_table';
  String colId = 'id';
  String colTitle = 'title';
  String colBudget = 'budget';
  String colDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get directory path for both Android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'wishes.db';
    // Open or create the database at a given path
    var wishesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return wishesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $wishTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      ' $colTitle TEXT, $colBudget REAL, $colPriority INTEGER, $colDate TEXT)',
    );
  }

  // Fetch: Get all wishes objs from db
  Future<List<Wish>> getAllWishesList() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> maps = await db.query('$wishTable');
    return List.generate(maps.length, (i) {
      return Wish(
        id: maps[i]['$colId'],
        title: maps[i]['$colTitle'],
        budget: maps[i]['$colBudget'],
        priority: maps[i]['$colPriority'],
        date: maps[i]['$colDate'],
      );
    });
  }

  // Insert
  Future<int> insertWish(Wish wish) async {
    Database db = await this.database;
    print(wish.title + " " + wish.date + " "+ wish.priority.toString() + " " + wish.budget.toString());
    var result = await db.insert(wishTable, wish.toMap());
    return result;
  }

  // Update
  Future<int> updateWish(Wish wish) async {
    Database db = await this.database;
    var result = await db.update(wishTable, wish.toMap(),
        where: '$colId = ? ', whereArgs: [wish.id]);
    return result;
  }

  // Delete
  Future<int> deleteWish(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $wishTable WHERE $colId = $id');
    return result;
  }

  // Get number of objs in db
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) from $wishTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
