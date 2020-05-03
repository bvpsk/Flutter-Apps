import 'package:flutter/material.dart';
import 'package:sudokuflutter/constants.dart';
import 'package:sudokuflutter/modules/reusable_card.dart';
import 'package:provider/provider.dart';
import 'package:sudokuflutter/models/puzzle_generator.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final int val;
  final Color color;
  final Widget child;
  CustomButton({this.val, this.onPressed, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      constraints: false,
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: .0, vertical: 10.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: kCustomButtonColor,
              width: kCustomButtonWidth,
            ),
            borderRadius: BorderRadius.circular(3)),
        color: color ?? kBackGroundColor,
        child: child ?? Text('$val', style: kCustomButtonTextStyle),
        onPressed: val == -1
            ? () {
                Provider.of<Game>(context).getHint();
              }
            : val == -2
                ? () {
                    Provider.of<Game>(context).undo();
                  }
                : val == -3
                    ? () {
                        Provider.of<Game>(context).resetGame();
                      }
                    : () {
                        Provider.of<Game>(context).changeValue(val);
                      },
      ),
    );
  }
}
