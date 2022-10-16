class FieldValidation {
  bool isEmailValid(String? email) {
    if (email == null) {
      return false;
    }
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
            r".[a-zA-Z]+")
        .hasMatch(email);
  }

  String? getNonEmptyValidation(String? value, String prompt) {
    if (value == null || value.isEmpty) {
      return prompt;
    }
    return null;
  }
}
