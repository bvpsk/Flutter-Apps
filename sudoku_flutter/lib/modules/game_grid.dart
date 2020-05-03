import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudokuflutter/modules/reusable_card.dart';
import 'package:sudokuflutter/constants.dart';
import 'package:sudokuflutter/modules/block.dart';
import 'package:sudokuflutter/models/puzzle_generator.dart';

class GameGrid extends StatefulWidget {
  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, gameData, child) {
        List<List<Block>> blocks = gameData.grid.blocks;
        return Column(
          children: <Widget>[
            Container(
              child: ReusableCard(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: kOuterBorderColor, width: kOuterBorderWidth),
                      borderRadius: BorderRadius.circular(kOuterBorderRadius)),
//                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      ReusableCard(
                        child: Row(
                          children: [
//                            BlockTile(
//                              borderColor: kBlockBorderColor,
//                              br: true,
//                              bb: true,
//                            ),
                            BlockTile(
                              cells: blocks[0][0].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                              bb: true,
                            ),
                            BlockTile(
                              cells: blocks[0][1].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                              bb: true,
                            ),
                            BlockTile(
                              cells: blocks[0][2].cells,
                              borderColor: kBlockBorderColor,
                              bb: true,
                            )
//                            BlockTile(
//                              borderColor: kBlockBorderColor,
//                              bb: true,
//                            )
                          ],
                        ),
                      ),
                      ReusableCard(
                        child: Row(
                          children: [
                            BlockTile(
                              cells: blocks[1][0].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                              bb: true,
                            ),
                            BlockTile(
                              cells: blocks[1][1].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                              bb: true,
                            ),
                            BlockTile(
                              cells: blocks[1][2].cells,
                              borderColor: kBlockBorderColor,
                              bb: true,
                            ),
                          ],
                        ),
                      ),
                      ReusableCard(
                        child: Row(
                          children: [
                            BlockTile(
                              cells: blocks[2][0].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                            ),
                            BlockTile(
                              cells: blocks[2][1].cells,
                              borderColor: kBlockBorderColor,
                              br: true,
                            ),
                            BlockTile(
                              cells: blocks[2][2].cells,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
