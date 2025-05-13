import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class PatientService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final String _patientsTableName = 'patients';
  final String _addressesTableName = 'addresses';

  final String _patientsIdColumnName = 'id';
  final String _patientsNameColumnName = 'name';
  final String _patientsCPFColumnName = 'cpf';
  final String _patientsPhoneColumnName = 'phone';
  final String _patientsBirthdayColumnName = 'birthday';
  final String _patientsGenderColumnName = 'gender';

  final String _cepColumnName = 'cep';
  final String _streetColumnName = 'street';
  final String _numberColumnName = 'number';
  final String _complementColumnName = 'complement';
  final String _neighborhoodColumnName = 'neighborhood';
  final String _cityColumnName = 'city';
  final String _stateColumnName = 'state';
  final String _patientIdColumnName = 'patient_id';

  static final PatientService instance = PatientService._constructor();
  PatientService._constructor();

  Future<void> savePatient(
    String name,
    String cpf,
    String phone,
    String birthday,
    String gender,
    String cep,
    String street,
    String number,
    String complement,
    String neighborhood,
    String city,
    String state,
  ) async {
    final db = await _databaseService.database;

    try {
      int _patientId = await db.insert(_patientsTableName, {
        _patientsNameColumnName: name,
        _patientsCPFColumnName: cpf,
        _patientsPhoneColumnName: phone,
        _patientsBirthdayColumnName: birthday,
        _patientsGenderColumnName: gender,
      }, conflictAlgorithm: ConflictAlgorithm.abort);

      print(_patientId);

      await db.insert(_addressesTableName, {
        _cepColumnName: cep,
        _streetColumnName: street,
        _numberColumnName: number,
        _complementColumnName: complement,
        _neighborhoodColumnName: neighborhood,
        _cityColumnName: city,
        _stateColumnName: state,
        _patientIdColumnName: _patientId
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Object?>> getPatientDataByCpf(String cpf) async {
    final db = await _databaseService.database;

    try {
      List<Map<String, Object?>> loggedDoctorMap = await db.query(
        _patientsTableName,
        where: '$_patientsCPFColumnName = ?',
        whereArgs: [cpf],
      );

      if (loggedDoctorMap.length == 0) {
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
