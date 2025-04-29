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

  Future<void> savePatient (
      String name,
      String cpf,
      String phone,
      String birthday,
      String gender
      ) async {

    final db = await _databaseService.database;

    try {
      await db.insert(
          _patientsTableName,
          {
            _patientsNameColumnName: name,
            _patientsCPFColumnName: cpf,
            _patientsPhoneColumnName: phone,
            _patientsBirthdayColumnName: birthday,
            _patientsGenderColumnName: gender
          },
          conflictAlgorithm: ConflictAlgorithm.abort
      );
    } catch(e) {
      rethrow;
    }

  }
}