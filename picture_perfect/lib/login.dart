import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pictureperfect/constants.dart';
import 'package:pictureperfect/input_field.dart';
import 'package:pictureperfect/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictureperfect/sign_up.dart';

import 'feed.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = '', password = '', emailErrorText = null, passwordErrorText = null;

  bool emailValidate = true, passwordValidate = true, _load = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator =_load? new Container(
      color: Colors.grey.withOpacity(0.3),
      child: Center(child: Container(
          width: 75,
          height: 75,
          child: CircularProgressIndicator())),
    ):new Container();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
//        physics: NeverScrollableScrollPhysics(),
            child: SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 100,
                              child: Hero(tag: 'main_logo',
                                  child: Image.asset('assets/images/icon1.png'))),
                          SizedBox(width: 20),
                          Text('Picture Perfect', style: titleTextStyle)
                        ]
                    ),
                    SizedBox(height: 100),
                    InputField(
                      hintText: "Enter Your Email",
                      labelText: 'Email',
                      errorText: emailErrorText,
                      onChanged: (val){
                        email = val;
                      },
                    ),
                    InputField(
                      hintText: "Enter Your Password",
                      labelText: 'Password',
                      errorText: passwordErrorText,
                      helperText: 'your password must be atleast 6 characters',
                      isPassword: true,
                      onChanged: (val){
                        password = val;
                      },
                    ),
                    SizedBox(height: 10),
                    Button(
                      text: "LogIn",
                      onTap: ()async{
                        //TODO: form validation
                        setState(() {
                          emailErrorText = null;
                          passwordErrorText = null;
                          _load = true;
                        });
                        try {
                          final newUser = await _auth.signInWithEmailAndPassword( //Initiating Login process
                              email: email, password: password);
                          setState(() {
                            _load = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Feed()), //redirecting to feed page
                          );
                        }catch(e){
                          print(e);
                          String emailMsg = null, passwordMsg = null;
                          if(e is PlatformException){
                            if(e.code == 'ERROR_INVALID_EMAIL'){ //Checking if email entered is not in format
                              emailMsg = 'Invalid Email Address';
                            }else if(e.code == 'ERROR_WRONG_PASSWORD'){ //Checking if password is correct or not
                              passwordMsg = 'Wrong Password';
                            }
                            else if(e.code == 'ERROR_USER_NOT_FOUND'){ //Checking if email entered registered or not
                              emailMsg = 'No user is registered with this email';
                            }
                          }
                          setState(() {// Updating respective fields with errors if found any
                            emailErrorText = email == '' ? 'Email must be filled'  :emailMsg;
                            passwordErrorText = password == '' ? 'Password must be filled' : passwordMsg;
                            _load = false;
                          });
                        }


                      },
                    ),
                    Button( // Link if user already exists
                      text: 'New User? Click Here to Sign Up',
                      margin_vertical: 0,
                      font_size: 14,
                      text_color: Colors.blueAccent,
                      padding_vertical: 3,
                      padding_horizontal: 5,
                      background_color: Colors.transparent,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(child: loadingIndicator,alignment: FractionalOffset.center) //Page progress loader
        ],
      )
    );
  }
}
