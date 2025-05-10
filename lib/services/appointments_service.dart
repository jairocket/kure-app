import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AppointmentsService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final String _appointmentsTableName = 'appointments';
  final String _doctorIdColumnName = 'doctor_id';
  final String _patientIdColumnName = 'patient_id';
  final String _patientsNameColumnName = 'name';
  final String _patientsCPFColumnName = 'cpf';
  final String _appointmentDateColumnName = 'date';
  final String _appointmentTimeColumnName = 'time';

  static final AppointmentsService instance = AppointmentsService._constructor();
  AppointmentsService._constructor();

  Future<void> saveAppointment(
    int doctor_id,
    int patient_id,
    String name,
    String cpf,
    String date,
    String time,
  ) async {
    final db = await _databaseService.database;

    print("vou tentar salvar");
    print('doctor $doctor_id');
    print('patient $patient_id');

    try {

      await db.insert(_appointmentsTableName, {
        _doctorIdColumnName: doctor_id,
        _patientIdColumnName: patient_id,
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
