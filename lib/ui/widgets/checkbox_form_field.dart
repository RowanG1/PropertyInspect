import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {FormFieldSetter<bool>? onSaved, required FormFieldValidator<bool> validator, bool initialValue = false, bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Checkbox(
                  value: state.value,
                  activeColor: Colors.green,
                  onChanged: (newValue) {
                    state.didChange(newValue ?? false);
                  });
            });
}
