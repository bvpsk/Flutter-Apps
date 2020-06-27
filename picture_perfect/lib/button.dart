import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final double margin_vertical, margin_horizontal, padding_vertical, padding_horizontal, border_radius, font_size;
  // ignore: non_constant_identifier_names
  final Color border_color, background_color, text_color;
  // ignore: non_constant_identifier_names
  final Function onTap;
  final String text;
  Button({this.margin_vertical = 32, this.margin_horizontal = 0, this.padding_vertical = 16, this.padding_horizontal = 32, this.border_radius = 5, this.font_size = 32, this.border_color = Colors.transparent, this.background_color = Colors.greenAccent, this.text_color = Colors.white, this.onTap = null, this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector( //for detecting button taps
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: margin_vertical, horizontal: margin_horizontal),
        padding: EdgeInsets.symmetric(vertical: padding_vertical, horizontal: padding_horizontal),
        decoration: BoxDecoration(
            border: Border.all(color: border_color),
            borderRadius: BorderRadius.circular(border_radius),
            color: background_color
        ),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: text_color,
                fontSize: font_size,
                fontWeight: FontWeight.bold,
            )
        ),
      ),
    );
  }
}