import 'package:myapp/src/api/db_provider.dart';
import 'package:myapp/src/models/student.dart';

class StudentRepository {
  final dbProvider = DBProvider.db;

  Future<int> createStudent(Student student) async {
    final db = await dbProvider.database;
    var res = await db.insert("students", student.toMap());
    return res;
  }

  Future<List<Student>> getAllStudents() async {
    final db = await dbProvider.database;
    var res = await db.query("students");
    List<Student> list = res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  Future<Student?> getStudentById(int id) async {
    final db = await dbProvider.database;
    var res = await db.query("students", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Student.fromMap(res.first) : null;
  }

  Future<int> updateStudent(Student student) async {
    final db = await dbProvider.database;
    var res = await db.update("students", student.toMap(), where: "id = ?", whereArgs: [student.id]);
    return res;
  }

  Future<int> deleteStudent(int id) async {
    final db = await dbProvider.database;
    var res = await db.delete("students", where: "id = ?", whereArgs: [id]);
    return res;
  }
}
