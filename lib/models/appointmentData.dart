class AppointmentData {
  final String date;
  final bool cancelled;
  final double price;

  AppointmentData(
      this.date,
      this.cancelled,
      this.price
      );
  
  Map<String, Object?> toMap() {
    return {
      'date': date,
      'cancelled': cancelled,
      'price': price
    };
  }

  @override
  String toString() {
    return 'Data {date: ${date}, cancelled: ${cancelled}, price ${price}';
  }
}