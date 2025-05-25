class AppointmentData {
  final int id;
  final String date;
  final bool cancelled;
  final double price;
  final String patientName;

  AppointmentData(
      this.id,
      this.date,
      this.cancelled,
      this.price,
      this.patientName
      );
  
  Map<String, Object?> toMap() {
    return {
      'date': date,
      'cancelled': cancelled,
      'price': price,
      'patientName': patientName
    };
  }

  @override
  String toString() {
    return 'Data {date: ${date}, cancelled: ${cancelled}, price ${price}, price ${patientName}';
  }
}