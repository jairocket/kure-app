class Patient {
  final int id;
  final String name;
  final String cpf;
  final String phoneNumber;
  final String gender;
  final String birthday;

  Patient(
    this.id,
    this.name,
    this.cpf,
    this.phoneNumber,
    this.gender,
    this.birthday
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'firstName': name,
      'cpf': cpf,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
  }

  @override
  String toString() {
    return 'Paciente {id: ${id}, name: ${name}, phoneNumber: ${phoneNumber}, cpf: ${cpf}, gênero: ${gender}, data de nascimento: ${birthday}}';
  }
}