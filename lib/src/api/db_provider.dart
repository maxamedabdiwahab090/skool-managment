import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "SchoolDB.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE users ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "username TEXT UNIQUE NOT NULL,"
          "password TEXT NOT NULL"
          ")");

      await db.execute("CREATE TABLE students ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "roll_number TEXT,"
          "photo_path TEXT,"
          "class_id INTEGER,"
          "section_id INTEGER,"
          "FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL,"
          "FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE SET NULL"
          ")");

      await db.execute("CREATE TABLE teachers ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "subject TEXT,"
          "phone_number TEXT"
          ")");

      await db.execute("CREATE TABLE classes ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL UNIQUE"
          ")");

      await db.execute("CREATE TABLE sections ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "class_id INTEGER,"
          "FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE"
          ")");

      await db.execute("CREATE TABLE attendance_students ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "student_id INTEGER NOT NULL,"
          "date TEXT NOT NULL,"
          "status TEXT NOT NULL," // e.g., 'Present', 'Absent', 'Late'
          "FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE"
          ")");

      await db.execute("CREATE TABLE attendance_teachers ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "teacher_id INTEGER NOT NULL,"
          "date TEXT NOT NULL,"
          "status TEXT NOT NULL," // e.g., 'Present', 'Absent', 'On-Leave'
          "FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE"
          ")");

      await db.execute("CREATE TABLE exams ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "date TEXT NOT NULL,"
          "class_id INTEGER,"
          "FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE"
          ")");

      await db.execute("CREATE TABLE results ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "student_id INTEGER NOT NULL,"
          "exam_id INTEGER NOT NULL,"
          "subject TEXT NOT NULL,"
          "marks REAL NOT NULL,"
          "FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,"
          "FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE"
          ")");

      await db.execute("CREATE TABLE fees ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "student_id INTEGER NOT NULL,"
          "amount REAL NOT NULL,"
          "due_date TEXT NOT NULL,"
          "status TEXT NOT NULL," // e.g., 'Paid', 'Unpaid'
          "FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE"
          ")");

      // Indexes for performance
      await db.execute("CREATE INDEX idx_student_name ON students (name)");
      await db.execute("CREATE INDEX idx_teacher_name ON teachers (name)");
      await db.execute(
          "CREATE INDEX idx_attendance_student_date ON attendance_students (date)");
      await db.execute(
          "CREATE UNIQUE INDEX idx_student_class_roll ON students (class_id, roll_number)");
    });
  }
}
