import 'package:flutter/material.dart';
import 'package:sudokuflutter/constants.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  final int flex;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final bool constraints;
  final bool br, bb, bt, bl;
  ReusableCard({
    this.child,
    this.flex = 1,
    this.borderWidth = 0.3,
    this.borderColor,
    this.backgroundColor,
    this.constraints = true,
    this.bb = false,
    this.br = false,
    this.bt = false,
    this.bl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
//        alignment: Alignment.center,
        constraints: constraints ? BoxConstraints.expand() : null,
        child: child,
        decoration: BoxDecoration(
          border: Border(
            top: bt
                ? BorderSide(
                    color: borderColor ?? kDefaultCellBorderColor,
                    width: borderWidth)
                : BorderSide.none,
            right: br
                ? BorderSide(
                    color: borderColor ?? kDefaultCellBorderColor,
                    width: borderWidth)
                : BorderSide.none,
            bottom: bb
                ? BorderSide(
                    color: borderColor ?? kDefaultCellBorderColor,
                    width: borderWidth)
                : BorderSide.none,
            left: bl
                ? BorderSide(
                    color: borderColor ?? kDefaultCellBorderColor,
                    width: borderWidth)
                : BorderSide.none,
          ),
          color: backgroundColor ?? Color(0x00ffffff),
//          color: backgroundColor ?? kBackGroundColor,
        ),
      ),
    );
  }
}
