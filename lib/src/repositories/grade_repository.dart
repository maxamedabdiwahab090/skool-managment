import 'package:myapp/src/models/grade.dart';
import 'package:myapp/src/services/database_helper.dart';

class GradeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> createGrade(Grade grade) async {
    final db = await _databaseHelper.database;
    await db.insert('grades', grade.toMap());
  }

  Future<List<Grade>> getGrades() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('grades');
    return List.generate(maps.length, (i) {
      return Grade.fromMap(maps[i]);
    });
  }

  Future<void> updateGrade(Grade grade) async {
    final db = await _databaseHelper.database;
    await db.update(
      'grades',
      grade.toMap(),
      where: 'id = ?',
      whereArgs: [grade.id],
    );
  }

  Future<void> deleteGrade(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
