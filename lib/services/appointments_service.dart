import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AppointmentsService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final String _appointmentsTableName = 'appointments';
  final String _doctorIdColumnName = 'doctor_id';
  final String _patientIdColumnName = 'patient_id';
  final String _appointmentDateColumnName = 'date';
  final String _appointmentTimeColumnName = 'time';

  static final AppointmentsService instance =
      AppointmentsService._constructor();
  AppointmentsService._constructor();

  Future<void> saveAppointment(
    int doctor_id,
    int patient_id,
    String date,
    String time,
  ) async {
    final db = await _databaseService.database;

    try {
      await db.insert(_appointmentsTableName, {
        _doctorIdColumnName: doctor_id,
        _patientIdColumnName: patient_id,
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
              WHERE a.doctor_id = ?
              ORDER BY a.date, a.time ASC;
          ''',
        [doctorId],
      );

      if (appointmentsMap.isEmpty) {
        return List<Map<String, Object>>.empty(growable: true);
      }

      return appointmentsMap.map(
        (appointment) => {
          "id": appointment["id"],
          "patient_name": appointment["patient_name"],
          "date": appointment["date"],
          "time": appointment["time"],
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isTimeSlotAvailable(
    int doctorId,
    String date,
    String time,
  ) async {
    final db = await _databaseService.database;

    final result = await db.query(
      _appointmentsTableName,
      where:
          '$_doctorIdColumnName = ? AND $_appointmentDateColumnName = ? AND $_appointmentTimeColumnName = ?',
      whereArgs: [doctorId, date, time],
    );

    return result.isEmpty;
  }

  Future<List<String>> getUnavailableTimes(String date, int doctorId) async {
    final db = await _databaseService.database;

    final result = await db.query(
      _appointmentsTableName,
      columns: [_appointmentTimeColumnName],
      where: '$_appointmentDateColumnName = ? AND $_doctorIdColumnName = ?',
      whereArgs: [date, doctorId],
    );

    return result
        .map((row) => row[_appointmentTimeColumnName] as String)
        .toList();
  }
}
