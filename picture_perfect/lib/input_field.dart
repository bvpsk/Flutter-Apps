import 'package:flutter/material.dart';
import 'package:pictureperfect/constants.dart';

class InputField extends StatelessWidget {
  final double marginVertical, marginHorizontal;
  final String hintText, labelText, helperText, errorText;
  final Function onChanged;
  final bool isPassword;

  const InputField({this.marginVertical = 1, this.marginHorizontal = 27, this.hintText, this.labelText, this.onChanged, this.isPassword = false, this.helperText = '', this.errorText = null});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: marginVertical, horizontal: marginHorizontal),
      child: TextField(
        obscureText: isPassword,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.teal)
          ),
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          errorText: errorText
        ),
      ),
    );
  }
}