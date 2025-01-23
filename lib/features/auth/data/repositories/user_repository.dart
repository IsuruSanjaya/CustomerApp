// data/repositories/user_repository.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserRepository {
  Future<List<Map<String, dynamic>>> getUserRecords() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'auth.db'),
    );
    try {
      final users = await database.query('user');
      return users;
    } catch (e) {
      throw Exception('Error reading data: $e');
    } finally {
      await database.close();
    }
  }

  Future<void> deleteUser(String userCode) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'auth.db'),
    );
    try {
      await database.delete(
        'user',
        where: 'userCode = ?',
        whereArgs: [userCode],
      );
    } catch (e) {
      throw Exception('Error deleting data: $e');
    } finally {
      await database.close();
    }
  }
}
