extension ExtString on String {
  bool get isValidEmail {
    final regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]+");
    return regExp.hasMatch(this);
  }

  bool get isValidPassword {
    final regExp = RegExp(
      r"^(?=.[A-Z])(?=.[a-z])(?=*?[0-9])(?=*?[#?!@$^&*-]).{8,}$",
    );
    return regExp.hasMatch(this);
  }

  bool get isValidPatientName {
    final regExp = RegExp(r"^[A-Z][a-z]");
    return regExp.hasMatch(this) && this.length > 1;
  }

  bool get isCPFValid {
    final regExp = RegExp(r"^[0-9]{11}");
    return regExp.hasMatch(this) && this.length == 11;
  }

  bool get isValidPhone {
    final regExp = RegExp(r"^\+?0[0-9]{10}$");
    return regExp.hasMatch(this);
  }

  bool get isGenderInputInvalid {   
    return this.isNotEmpty;
  }
}
