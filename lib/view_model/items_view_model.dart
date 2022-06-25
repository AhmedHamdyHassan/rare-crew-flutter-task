import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ItemsViewModel {
  static const _dbName = 'myItemsDataBase.db';
  static const _dbVersion = 1;
  static const _tableName = 'items';
  static const _columnId = '_id';
  static const _columnName = 'name';
  static const _columnCost = 'cost';

  ItemsViewModel._privateConstructor();
  static final ItemsViewModel instance = ItemsViewModel._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    _database = await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
              CREATE TABLE $_tableName (
                $_columnId INTEGER PRIMARY KEY,
                $_columnName TEXT NOT NULL,
                $_columnCost TEXT NOT NULL)
             ''');
    });
  }

  //Database CRUD
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(_tableName, row,
        where: '$_columnId = ?', whereArgs: [row[_columnId]]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> singleElement = await db.query(_tableName);
    final returnedElement = singleElement.reduce((value, element) {
      if (value['_id'] == id) {
        return value;
      } else {
        return element;
      }
    });
    return returnedElement;
  }
}
