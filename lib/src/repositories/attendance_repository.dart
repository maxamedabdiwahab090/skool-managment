import 'package:myapp/src/api/db_provider.dart';
import 'package:myapp/src/models/attendance.dart';

class AttendanceRepository {
  final dbProvider = DBProvider.db;

  Future<int> createStudentAttendance(Attendance attendance) async {
    final db = await dbProvider.database;
    var res = await db.insert("student_attendance", attendance.toMap());
    return res;
  }

  Future<int> createTeacherAttendance(Attendance attendance) async {
    final db = await dbProvider.database;
    var res = await db.insert("teacher_attendance", attendance.toMap());
    return res;
  }

  Future<List<Attendance>> getStudentAttendanceByDate(DateTime date) async {
    final db = await dbProvider.database;
    var res = await db.query("student_attendance", where: "date = ?", whereArgs: [date.toIso8601String()]);
    List<Attendance> list = res.isNotEmpty ? res.map((c) => Attendance.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Attendance>> getTeacherAttendanceByDate(DateTime date) async {
    final db = await dbProvider.database;
    var res = await db.query("teacher_attendance", where: "date = ?", whereArgs: [date.toIso8601String()]);
    List<Attendance> list = res.isNotEmpty ? res.map((c) => Attendance.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateStudentAttendance(Attendance attendance) async {
    final db = await dbProvider.database;
    var res = await db.update("student_attendance", attendance.toMap(), where: "id = ?", whereArgs: [attendance.id]);
    return res;
  }

  Future<int> updateTeacherAttendance(Attendance attendance) async {
    final db = await dbProvider.database;
    var res = await db.update("teacher_attendance", attendance.toMap(), where: "id = ?", whereArgs: [attendance.id]);
    return res;
  }

  Future<int> deleteAttendance(int id, String table) async {
    final db = await dbProvider.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
