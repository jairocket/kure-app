class Appointment {
  final int id;
  final String patient_name;
  final String time;
  final String date;

  Appointment(
      this.id,
      this.patient_name,
      this.time,
      this.date,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'patient_name': patient_name,
      'time': time,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Paciente {id: ${id}, patient_name: ${patient_name}, time: ${time}, date: ${date}}';
  }
}