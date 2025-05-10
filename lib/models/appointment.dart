class Appointment {
  final int doctor_id;
  final String patient_name;
  final String time;
  final String date;

  Appointment(
      this.doctor_id,
      this.patient_name,
      this.time,
      this.date,
      );

  Map<String, Object?> toMap() {
    return {
      'doctor_id': doctor_id,
      'patient_name': patient_name,
      'time': time,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Paciente {doctor_id: ${doctor_id}, patient_name: ${patient_name}, time: ${time}, date: ${date}}';
  }
}