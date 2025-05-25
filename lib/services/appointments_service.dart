import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AppointmentsService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final _appointmentsTableName = 'appointments';
  final _doctorIdColumnName = 'doctor_id';
  final _patientIdColumnName = 'patient_id';
  final _appointmentIdColumnName = 'id';
  final _appointmentDateColumnName = 'date';
  final _appointmentTimeColumnName = 'time';
  final _cancelledAppointmentColumnName = 'cancelled';
  final _appointmentPriceInCents = 'price_in_cents';

  static final AppointmentsService instance =
      AppointmentsService._constructor();
  AppointmentsService._constructor();

  Future<void> saveAppointment(
    int doctor_id,
    int patient_id,
    String date,
    String time,
    int priceInCents,
  ) async {
    final db = await _databaseService.database;

    try {
      await db.insert(_appointmentsTableName, {
        _doctorIdColumnName: doctor_id,
        _patientIdColumnName: patient_id,
        _appointmentDateColumnName: date,
        _appointmentTimeColumnName: time,
        _cancelledAppointmentColumnName: 0,
        _appointmentPriceInCents: priceInCents,
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      rethrow;
    }
  }

  Future<Iterable<Map<String, Object?>>> getTodayNotCancelledAppointments(
    int doctorId,
  ) async {
    final db = await _databaseService.database;
    final _notCancelled = 0;

    try {
      List<Map<String, Object?>> appointmentsMap = await db.rawQuery(
        ''' 
            SELECT a.id, a.date, a.time, a.cancelled, p.name as patient_name FROM $_appointmentsTableName a
              INNER JOIN patients p ON p.id = a.patient_id 
              WHERE a.doctor_id = ? AND a.cancelled = ? AND DATE(a.date) = DATE('now')
              ORDER BY a.date, a.time ASC;
          ''',
        [doctorId, _notCancelled],
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
          "cancelled": appointment["cancelled"],
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
    final _notCancelled = 0;

    final result = await db.query(
      _appointmentsTableName,
      where: '''
          $_doctorIdColumnName = ? AND 
          $_appointmentDateColumnName = ? AND 
          $_appointmentTimeColumnName = ? AND 
          $_cancelledAppointmentColumnName = $_notCancelled
          ''',
      whereArgs: [doctorId, date, time],
    );

    return result.isEmpty;
  }

  Future<List<String>> getUnavailableTimes(String date, int doctorId) async {
    final db = await _databaseService.database;
    final _notCancelled = 0;

    final result = await db.query(
      _appointmentsTableName,
      columns: [_appointmentTimeColumnName],
      where: '''
        $_appointmentDateColumnName = ? AND 
        $_doctorIdColumnName = ? AND 
        $_cancelledAppointmentColumnName = ${_notCancelled}
        ''',
      whereArgs: [date, doctorId],
    );

    return result
        .map((row) => row[_appointmentTimeColumnName] as String)
        .toList();
  }

  Future<void> cancelAppointmentById(int id) async {
    final db = await _databaseService.database;

    await db.update(
      _appointmentsTableName,
      {_cancelledAppointmentColumnName: 1},
      where: '$_appointmentIdColumnName = ?',
      whereArgs: [id],
    );
  }

  Future<Iterable<Map<String, Object?>>> getAllAppointments(
    int doctorId,
  ) async {
    final db = await _databaseService.database;

    List<Map<String, Object?>> appointmentsMap = await db.rawQuery(
      """
        SELECT a.id, a.date, a.cancelled, a.price_in_cents, p.name as patient_name FROM appointments a
          INNER JOIN patients p ON p.id = a.patient_id
          WHERE a.doctor_id = ?
      """,
      [doctorId],
    );

    return appointmentsMap.map(
      (appointment) => {
        "id": appointment["id"],
        "cancelled": appointment["cancelled"],
        "price_in_cents": appointment["price_in_cents"],
        "date": appointment["date"],
        "patient_name": appointment["patient_name"]
      },
    );
  }

  Future<void> updateAppointment(
    appointmentId,
    date,
    time,
    priceInCents,
  ) async {
    final db = await _databaseService.database;

    await db.update(
      _appointmentsTableName,
      {"date": date, "time": time, "price_in_cents": priceInCents},
      where: '$_appointmentIdColumnName = ?',
      whereArgs: [appointmentId],
    );
  }

  Future<Map<String, Object?>?> getAppointmentById(int id) async {
    final db = await _databaseService.database;

    try {
      List<Map<String, Object?>> appointmentsMap = await db.rawQuery(
        '''
            SELECT a.date, a.time, a.price_in_cents, p.name as patient_name, p.cpf as patient_cpf FROM $_appointmentsTableName a
              INNER JOIN patients p ON p.id = a.patient_id 
              WHERE a.id = ?
          ''',
        [id],
      );

      if (appointmentsMap.isEmpty) {
        return null;
      }
      return {
        "patient_name": appointmentsMap.first["patient_name"] as String,
        "patient_cpf": appointmentsMap.first["patient_cpf"] as String,
        "date": appointmentsMap.first["date"] as String,
        "time": appointmentsMap.first["time"] as String,
        "price_in_cents": appointmentsMap.first["price_in_cents"] as int,
      };
    } catch (e) {
      rethrow;
    }
  }
}
