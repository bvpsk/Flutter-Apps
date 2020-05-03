import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xdd3c8fad)),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Congratulations!!!\n\nYou have solved the puzzle.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            FlatButton(
              color: Colors.yellowAccent,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.greenAccent,
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                'Play Again!',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
