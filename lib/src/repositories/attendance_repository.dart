import 'package:myapp/src/models/attendance.dart';
import 'package:myapp/src/services/database_helper.dart';

class AttendanceRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> markAttendance(Attendance attendance) async {
    final db = await _databaseHelper.database;
    await db.insert('attendance', attendance.toMap());
  }

  Future<List<Attendance>> getAttendanceByDate(DateTime date) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }
}
