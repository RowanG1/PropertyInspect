import '../constants.dart';

class FieldValidation {
  bool isEmailValid(String? email) {
    if (email == null) {
      return false;
    }
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
            r".[a-zA-Z]+")
        .hasMatch(email);
  }

  String? getEmailValidation(String? email) {
   return  isEmailValid(email) ? null : Constants.emailValidationLabel;
  }

  String? getNonEmptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.defaultValidationLabel;
    }
    return null;
  }
}
