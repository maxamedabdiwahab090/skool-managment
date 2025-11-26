import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/services/database_helper.dart';

class TeacherRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> createTeacher(Teacher teacher) async {
    final db = await _databaseHelper.database;
    await db.insert('teachers', teacher.toMap());
  }

  Future<List<Teacher>> getTeachers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('teachers');
    return List.generate(maps.length, (i) {
      return Teacher.fromMap(maps[i]);
    });
  }

  Future<void> updateTeacher(Teacher teacher) async {
    final db = await _databaseHelper.database;
    await db.update(
      'teachers',
      teacher.toMap(),
      where: 'id = ?',
      whereArgs: [teacher.id],
    );
  }

  Future<void> deleteTeacher(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'teachers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
