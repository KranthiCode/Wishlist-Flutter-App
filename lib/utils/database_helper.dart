import 'dart:async';
import 'dart:io';

import 'package:myapp/models/wish.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String wishTable = 'wish_table';
  String colId = 'id';
  String colTitle = 'title';
  String colBudget = 'budget';
  String colDate = 'date';
  String colPriority = 'priority';
  String colIsBudgetNeeded = 'isBudgetNeeded';
  String colIsTimeBound = 'isTimeBound';
  String colStatus = 'status';

  DatabaseHelper._createInstance() {
    print("creating indtance for databasehelper");
  }

  factory DatabaseHelper() {
    print("inside database helper factory");
    if (_databaseHelper == null) {
      print("database helper is null so creating instace to it");
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    print('in get database');
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    print("inside initialize database");
    // Get directory path for both Android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'wishes.db';
    // Open or create the database at a given path
    var wishesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return wishesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    print("inside _createDb");
    await db.execute(
      'CREATE TABLE $wishTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      ' $colTitle TEXT, $colBudget REAL, $colPriority INTEGER, $colDate TEXT,'
      ' $colIsBudgetNeeded TEXT, $colIsTimeBound TEXT, $colStatus TEXT)',
    );
  }

  // Fetch: Get all wishes objs from db
  Future<List<Wish>> getAllInprogressWishesList() async {
    print('inside get inprogress wishes list');
    Database db = await this.database;
    final List<Map<String, dynamic>> maps = await db.query('$wishTable',
        where: '$colStatus = ?', whereArgs: ["IN_PROGRESS"]);
    return List.generate(maps.length, (i) {
      return Wish(
        id: maps[i]['$colId'],
        title: maps[i]['$colTitle'],
        budget: maps[i]['$colBudget'],
        priority: maps[i]['$colPriority'],
        date: maps[i]['$colDate'],
        isTimeBound: maps[i]['$colIsTimeBound'],
        isBudgetNeeded: maps[i]['$colIsBudgetNeeded'],
        status: maps[i]['$colStatus'],
      );
    });
  }

  Future<List<Wish>> getAllCompletedWishesList() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> maps = await db
        .query('$wishTable', where: '$colStatus = ?', whereArgs: ["COMPLETED"]);
    return List.generate(maps.length, (i) {
      return Wish(
        id: maps[i]['$colId'],
        title: maps[i]['$colTitle'],
        budget: maps[i]['$colBudget'],
        priority: maps[i]['$colPriority'],
        date: maps[i]['$colDate'],
        isTimeBound: maps[i]['$colIsTimeBound'],
        isBudgetNeeded: maps[i]['$colIsBudgetNeeded'],
        status: maps[i]['$colStatus'],
      );
    });
  }

  Future<List<Wish>> getAllWishesList() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> maps = await db.query('$wishTable');
    return List.generate(maps.length, (i) {
      print("is budget needed: " + maps[i]['$colIsBudgetNeeded']);
      print("is time needed: " + maps[i]['$colIsTimeBound']);
      return Wish(
        id: maps[i]['$colId'],
        title: maps[i]['$colTitle'],
        budget: maps[i]['$colBudget'],
        priority: maps[i]['$colPriority'],
        date: maps[i]['$colDate'],
        isTimeBound: maps[i]['$colIsTimeBound'] == 'true' ? true : false,
        isBudgetNeeded: maps[i]['$colIsBudgetNeeded'] == 'true' ? true : false,
        status: maps[i]['$colStatus'],
      );
    });
  }

  // Insert
  Future<int> insertWish(Wish wish) async {
    Database db = await this.database;
    print(wish.title +
        " " +
        wish.date +
        " " +
        wish.priority.toString() +
        " " +
        wish.budget.toString() +
        " " +
        wish.isBudgetNeeded.toString() +
        " " +
        wish.isTimeBound.toString());
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
