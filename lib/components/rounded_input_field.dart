import 'package:flutter/material.dart';
import 'text_field_container.dart';
import 'package:chatbot/constants.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.validator,
    this.obsecureText,
    this.labelText,
    this.initialValue,
    this.inputType,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final bool obsecureText;
  final String labelText;
  final String initialValue;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: inputType,
        initialValue: initialValue,
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: kPrimaryColor,
          ),
          icon: Icon(
            icon,
            color: kPrimaryTextColor,
          ),
          hintText: hintText,
          focusColor: kPrimaryColor,
        ),
      ),
    );
  }
}
