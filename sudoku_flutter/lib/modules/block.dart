import 'package:flutter/material.dart';
import 'package:sudokuflutter/constants.dart';
import 'package:sudokuflutter/modules/reusable_card.dart';
import 'package:sudokuflutter/modules/tile.dart';
import 'package:sudokuflutter/models/puzzle_generator.dart';

class BlockTile extends StatefulWidget {
  final List<Cell> cells;
  final Color borderColor;
  final double borderWidth;
  final bool br, bb, bl, bt;
  BlockTile(
      {this.borderColor,
      this.borderWidth = 1,
      this.bb = false,
      this.bl = false,
      this.br = false,
      this.bt = false,
      this.cells});

  @override
  _BlockTileState createState() => _BlockTileState();
}

class _BlockTileState extends State<BlockTile> {
  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      br: widget.br,
      bb: widget.bb,
      bl: widget.bl,
      bt: widget.bt,
      flex: 1,
      child: Column(
        children: [
          ReusableCard(
            child: Row(
              children: [
                ReusableCard(
                  child: Tile(cell: widget.cells[0]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                  bb: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[1]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                  bb: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[2]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  bb: true,
                )
              ],
            ),
          ),
          ReusableCard(
            child: Row(
              children: [
                ReusableCard(
                  child: Tile(cell: widget.cells[3]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                  bb: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[4]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                  bb: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[5]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  bb: true,
                )
              ],
            ),
          ),
          ReusableCard(
            child: Row(
              children: [
                ReusableCard(
                  child: Tile(cell: widget.cells[6]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[7]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                  br: true,
                ),
                ReusableCard(
                  child: Tile(cell: widget.cells[8]),
                  borderColor: kCellBorderColor,
                  borderWidth: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
