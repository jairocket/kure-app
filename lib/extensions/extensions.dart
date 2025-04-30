extension ExtString on String {
  bool get isValidEmail {
    final regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]+");
    return regExp.hasMatch(this);
  }

  bool get isValidPassword {
    final regExp = RegExp(
      r"^(?=.*[A-Z])(?=.*[!#@$^%&])(?=.*[0-9])(?=.*[a-z]).{8,15}$",
    );
    return regExp.hasMatch(this) && this.trim().length >= 8;
  }

  bool get isValidPatientName {
    final regExp = RegExp(r"\w");
    return regExp.hasMatch(this) && this.length > 1;
  }

  bool get isCPFValid {
    final regExp = RegExp(r"^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}");
    return regExp.hasMatch(this) && this.length == 14;
  }

  bool get isValidPhone {  
    return this.length == 15;
  }

  bool get isGenderInputInvalid {   
    return this.isNotEmpty;
  }
}
