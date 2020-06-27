import 'package:flutter/material.dart';
import 'package:pictureperfect/button.dart';
import 'package:pictureperfect/login.dart';
import 'package:pictureperfect/sign_up.dart';
class AccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container( // App Logo with hero animation enabled
              width: 300,
              child: Hero(tag: 'main_logo',
                  child: Image.asset('assets/images/icon1.png'))),
          SizedBox(height: 65),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                // Custom Button Widget made for reusability
                child: Button(text: 'Sign Up',
                  margin_horizontal: 10,
                  onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()), // Redirecting to SignUp Page
                  );
                },),
              ),
              Expanded(
                child: Button(text: 'Log In',
                    margin_horizontal: 10,
                    onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()), // Redirecting to LogIn Page
                  );
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}