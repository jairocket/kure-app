import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class DoctorService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final String _doctorTableName = 'doctors';
  final String _doctorIdColumnName = 'id';
  final String _doctorNameColumnName = 'name';
  final String _doctorCRMColumnName = 'crm';
  final String _doctorPhoneColumnName = 'phone';
  final String _doctorPasswordColumnName = 'password';
  final String _doctorEmailColumnName = 'email';

  static final DoctorService instance = DoctorService._constructor();

  DoctorService._constructor();

  Future<void> saveDoctor(
    String name,
    String crm,
    String phone,
    String email,
    String password,
  ) async {
    final db = await _databaseService.database;

    try {
      await db.insert(_doctorTableName, {
        _doctorNameColumnName: name,
        _doctorCRMColumnName: crm,
        _doctorPhoneColumnName: phone,
        _doctorEmailColumnName: email,
        _doctorPasswordColumnName: password,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Object?>> logIn(String email, String password) async {
    final db = await _databaseService.database;
    try {
      List<Map<String, Object?>> loggedDoctorMap = await db.query(
        _doctorTableName,
        where: 'email = ? and password = ?',
        whereArgs: [email, password],
      );

      if(loggedDoctorMap.length > 1) {
        throw Exception("Algo de errado");
      }

      if(loggedDoctorMap.length == 0) {
        throw Exception("Credenciais inválidas");
      }

      return {
        "id": loggedDoctorMap.first[_doctorIdColumnName],
        "name": loggedDoctorMap.first[_doctorNameColumnName],
        "crm": loggedDoctorMap.first[_doctorCRMColumnName]
      };
    } catch (e) {
      rethrow;
    }
  }

      Future<void> changePasswordByEmail(String email, String newPassword) async {
    final db = await _databaseService.database;

    final result = await db.query(
      'doctors',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      throw Exception("Usuário com e-mail $email não encontrado.");
    }

    await db.update(
      'doctors',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
