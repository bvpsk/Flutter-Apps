import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudokuflutter/models/puzzle_generator.dart';

class Tile extends StatelessWidget {
  Tile({this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        print(Provider.of<Game>(context).grid.blocks[0]);
        Provider.of<Game>(context).setStyle(cell, 'currentActive');
//        print(cell.value);
      },
      child: Container(
        padding: EdgeInsets.all(2.0),
        color: cell.blockContainerColor,
        child: Container(
          decoration: cell.decoration,
          alignment: Alignment.center,
          child: Text(
            cell.text,
            style: cell.textStyle,
          ),
        ),
      ),
    );
  }
}
