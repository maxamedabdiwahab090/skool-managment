import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "school.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            rollNumber TEXT,
            age INTEGER,
            grade TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE teachers (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            subject TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE fees (
            id INTEGER PRIMARY KEY,
            studentId INTEGER NOT NULL,
            amount REAL NOT NULL,
            dueDate TEXT NOT NULL,
            status TEXT NOT NULL
          )
          ''');
  }
}
