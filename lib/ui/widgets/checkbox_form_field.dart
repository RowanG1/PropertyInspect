import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  static Color getFillColor(Set<MaterialState> states) {
    return Colors.grey;
  }

  static Color getFillColorError(Set<MaterialState> states) {
    return Colors.red;
  }

  static MaterialStateColor getFillMaterialStateColor(String? error) {
    if (error != null) {
      return MaterialStateColor.resolveWith(getFillColorError);
    } else {
      return MaterialStateColor.resolveWith(getFillColor);
    }
  }

  CheckboxFormField(
      {FormFieldSetter<bool>? onSaved, required FormFieldValidator<bool> validator, bool initialValue = false, bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Checkbox(
                  value: state.value,
                  activeColor: !state.hasError ? Colors.green : Colors.red,
                  fillColor: getFillMaterialStateColor(state.errorText),
                  onChanged: (newValue) {
                    state.didChange(newValue ?? false);
                  });
            });
}
