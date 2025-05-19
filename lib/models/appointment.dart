class Appointment {
  final int id;
  final String patient_name;
  final String time;
  final String date;
  final bool cancelled;

  Appointment(
      this.id,
      this.patient_name,
      this.time,
      this.date,
      this.cancelled
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'patient_name': patient_name,
      'time': time,
      'date': date,
      'cancelled': cancelled
    };
  }

  @override
  String toString() {
    return 'Paciente {id: ${id}, patient_name: ${patient_name}, time: ${time}, date: ${date}, cancelled: ${cancelled}} ';
  }
}