import 'package:flutter/material.dart';
import 'package:pictureperfect/access_page.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          // App Entry Page
          child: AccessPage(),
        ),
      ),
    );
  }
}




