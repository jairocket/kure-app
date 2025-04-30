import 'dart:convert';

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

  Future<void> saveDoctor (
      String name,
      String crm,
      String phone,
      String email,
      String password
      ) async {
    final db = await _databaseService.database;

    try {
      await db.insert(
          _doctorTableName,
          {
            _doctorNameColumnName: name,
            _doctorCRMColumnName: crm,
            _doctorPhoneColumnName: phone,
            _doctorEmailColumnName: email,
            _doctorPasswordColumnName: password
          },
          conflictAlgorithm: ConflictAlgorithm.abort
      );
    } catch (e) {
      rethrow;
    }
  }

  String _hashPassword(String password) {
    List<int> passwordBytes = utf8.encode(password);
    return base64Encode(passwordBytes);
  }

}