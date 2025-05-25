class AppointmentData {
  final int id;
  final String date;
  final bool cancelled;
  final double price;
  final String time;
  final String patientName;
  final String cpf;

  AppointmentData(
      this.id,
      this.date,
      this.cancelled,
      this.price,
      this.time,
      this.patientName,
      this.cpf
      );
  
  Map<String, Object?> toMap() {
    return {
      'date': date,
      'cancelled': cancelled,
      'price': price,
      'patientName': patientName,
      'cpf': cpf
    };
  }

  @override
  String toString() {
    return 'Data {date: ${date}, cancelled: ${cancelled}, price ${price}, patient_name ${patientName}, cpf ${cpf}';
  }
}