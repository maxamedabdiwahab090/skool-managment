import 'package:myapp/src/models/fee.dart';
import 'package:myapp/src/services/database_helper.dart';

class FeeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> createFee(Fee fee) async {
    final db = await _databaseHelper.database;
    await db.insert('fees', fee.toMap());
  }

  Future<List<Fee>> getFees() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('fees');
    return List.generate(maps.length, (i) {
      return Fee.fromMap(maps[i]);
    });
  }

  Future<void> updateFee(Fee fee) async {
    final db = await _databaseHelper.database;
    await db.update(
      'fees',
      fee.toMap(),
      where: 'id = ?',
      whereArgs: [fee.id],
    );
  }

  Future<void> deleteFee(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'fees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
