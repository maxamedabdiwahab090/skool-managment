import 'package:myapp/src/api/db_provider.dart';
import 'package:myapp/src/models/teacher.dart';

class TeacherRepository {
  final dbProvider = DBProvider.db;

  Future<int> createTeacher(Teacher teacher) async {
    final db = await dbProvider.database;
    var res = await db.insert("teachers", teacher.toMap());
    return res;
  }

  Future<List<Teacher>> getAllTeachers() async {
    final db = await dbProvider.database;
    var res = await db.query("teachers");
    List<Teacher> list = res.isNotEmpty ? res.map((c) => Teacher.fromMap(c)).toList() : [];
    return list;
  }

  Future<Teacher?> getTeacherById(int id) async {
    final db = await dbProvider.database;
    var res = await db.query("teachers", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Teacher.fromMap(res.first) : null;
  }

  Future<int> updateTeacher(Teacher teacher) async {
    final db = await dbProvider.database;
    var res = await db.update("teachers", teacher.toMap(), where: "id = ?", whereArgs: [teacher.id]);
    return res;
  }

  Future<int> deleteTeacher(int id) async {
    final db = await dbProvider.database;
    var res = await db.delete("teachers", where: "id = ?", whereArgs: [id]);
    return res;
  }
}
