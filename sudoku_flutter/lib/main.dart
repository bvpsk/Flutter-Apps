import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'constants.dart';
import 'package:flutter/services.dart';
//Photo by Manuel Will on Unsplash
//Icons made by <a href="https://www.flaticon.com/authors/smalllikeart" title="smalllikeart">smalllikeart</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: kBackGroundColor,
      ),
      home: GameScreen(),
    );
  }
}
