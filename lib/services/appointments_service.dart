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

  Future<Iterable<Map<String, Object?>>> getAppointments(int doctorId) async {
    final db = await _databaseService.database;
    try {
      List<Map<String, Object?>> appointmentsMap = await db.rawQuery(
          '''
            SELECT a.id, a.date, a.time, p.name as patient_name FROM $_appointmentsTableName a
              INNER JOIN patients p ON p.id = a.patient_id 
              WHERE a.doctor_id = ?;
          ''',
        [doctorId]
      );
      if(appointmentsMap.isEmpty) {
        return [];
      }

      print(appointmentsMap.first["id"]);
      print(appointmentsMap.first["patient_name"]);
      print(appointmentsMap.first["date"]);
      print(appointmentsMap.first["times"]);

      return appointmentsMap.map(
              (appointment) => {
                "id": appointment["id"],
                "patient_name": appointment["patient_name"],
                "date": appointment["date"],
                "time": appointment["time"]
              }
      );
    } catch(e){
      rethrow;
    }
  }

}
