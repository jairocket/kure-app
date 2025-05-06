import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AppoitmentsService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final String _appointmentsTableName = 'appointments';
  final String _patientsIdColumnName = 'id';
  final String _patientsNameColumnName = 'name';
  final String _patientsCPFColumnName = 'cpf';
  final String _appointmentDateColumnName = 'date';
  final String _appointmentTimeColumnName = 'time';

  static final AppoitmentsService instance = AppoitmentsService._constructor();
  AppoitmentsService._constructor();

  Future<void> saveAppointment(
    String name,
    String cpf,
    String date,
    String time,
  ) async {
    final db = await _databaseService.database;

    try {

      await db.insert(_appointmentsTableName, {
        _patientsNameColumnName: name,
        _patientsCPFColumnName: cpf,
        _appointmentDateColumnName: date,
        _appointmentTimeColumnName: time,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      rethrow;
    }
  }
}
