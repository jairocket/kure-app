import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class PatientService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final String _patientsTableName = 'patients';
  final String _patientsIdColumnName = 'id';
  final String _patientsNameColumnName = 'name';
  final String _patientsCPFColumnName = 'cpf';
  final String _patientsPhoneColumnName = 'phone';
  final String _patientsBirthdayColumnName = 'birthday';
  final String _patientsGenderColumnName = 'gender';

  static final PatientService instance = PatientService._constructor();
  PatientService._constructor();

  Future<void> savePatient(
    String name,
    String cpf,
    String phone,
    String birthday,
    String gender,
  ) async {
    final db = await _databaseService.database;

    try {
      await db.insert(_patientsTableName, {
        _patientsNameColumnName: name,
        _patientsCPFColumnName: cpf,
        _patientsPhoneColumnName: phone,
        _patientsBirthdayColumnName: birthday,
        _patientsGenderColumnName: gender,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getPatientNameByCpf(String cpf) async {
    final db = await _databaseService.database;

    final result = await db.query(
      _patientsTableName,
      columns: [_patientsNameColumnName],
      where: '$_patientsCPFColumnName = ?',
      whereArgs: [cpf],
    );

    if (result.isNotEmpty) {
      return result.first[_patientsNameColumnName] as String;
    }
    return null;
  }

  Future<Map<String, Object?>> getPatientDataByCpf(String cpf) async {
    final db = await _databaseService.database;
    try {
      List<Map<String, Object?>> loggedDoctorMap = await db.query(
        _patientsTableName,
        where: '$_patientsCPFColumnName = ?',
        whereArgs: [cpf],
      );

      if(loggedDoctorMap.length == 0) {
        throw Exception("Paciente nao encontrado");
      }

      return {
        "id": loggedDoctorMap.first[_patientsIdColumnName],
        "name": loggedDoctorMap.first[_patientsNameColumnName],
      };
    } catch (e) {
      rethrow;
    }
  }

}
