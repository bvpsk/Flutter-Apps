import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudokuflutter/constants.dart';
import 'package:sudokuflutter/modules/reusable_card.dart';
import 'package:sudokuflutter/models/puzzle_generator.dart';
import 'package:sudokuflutter/modules/game_grid.dart';
import 'package:sudokuflutter/modules/custom_button.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Game(context: context),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/stars1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xdd3c8fad),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1,
                  child: GameGrid(),
                ),
                SizedBox(height: 15),
//              Text('CLEAR', style: kCustomButtonTextStyleCross)
                ReusableCard(
                  child: Row(
                    children: [
                      ReusableCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomButton(val: 1),
                                SizedBox(width: 5),
                                CustomButton(val: 2),
                                SizedBox(width: 5),
                                CustomButton(val: 3),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomButton(val: 4),
                                SizedBox(width: 5),
                                CustomButton(val: 5),
                                SizedBox(width: 5),
                                CustomButton(val: 6),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomButton(val: 7),
                                SizedBox(width: 5),
                                CustomButton(val: 8),
                                SizedBox(width: 5),
                                CustomButton(val: 9),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      ReusableCard(
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                CustomButton(
                                    val: 0,
                                    color: kFunctionalButtonColor,
                                    child: Text('CLEAR',
                                        style: kCustomButtonTextStyleClear)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                CustomButton(
                                  color: kHintTextColor,
                                  val: -1,
                                  child: Icon(
                                    Icons.lightbulb_outline,
                                    color: kHintBoxColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                CustomButton(
                                    val: -2,
                                    color: kFunctionalButtonColor,
                                    child: Icon(
                                      Icons.undo,
                                      color: kIconColor,
                                    )),
                                SizedBox(width: 5),
                                CustomButton(
                                    val: -3,
                                    color: kFunctionalButtonColor,
                                    child: Icon(
                                      Icons.autorenew,
                                      color: kIconColor,
                                    ))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
//                child: Row(
//                  children: [
//                    CustomButton(val: -1),
//                  ],
//                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
