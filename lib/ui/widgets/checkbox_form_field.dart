import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key, FormFieldSetter<bool>? onSaved, required FormFieldValidator<bool> validator, bool initialValue = false, bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Checkbox(
                  value: state.value,
                  activeColor: Colors.green,
                  fillColor: getFillMaterialStateColor(state.errorText),
                  onChanged: (newValue) {
                    state.didChange(newValue ?? false);
                  });
            });

  static MaterialStateColor getFillMaterialStateColor(String? error) {
    if (error != null) {
      return MaterialStateColor.resolveWith(getFillColorError);
    } else {
      return MaterialStateColor.resolveWith(getDefaultFillColor);
    }
  }

  static Color getDefaultFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.green;
    }
    return Colors.grey;
  }

  static Color getFillColorError(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.green;
    }
    return Colors.red;
  }
}
