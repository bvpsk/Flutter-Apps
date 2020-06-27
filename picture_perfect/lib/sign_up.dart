import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pictureperfect/constants.dart';
import 'package:pictureperfect/feed.dart';
import 'package:pictureperfect/input_field.dart';
import 'package:pictureperfect/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '', password = '', number = '', name = '', nameErrorText = null, emailErrorText = null, passwordErrorText = null, numberErrorText = null;

  bool _load = false;

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
          SingleChildScrollView( //To Enable Scrolling
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
                          Container( // Hero Icon
                              width: 100,
                              child: Hero(tag: 'main_logo',
                                  child: Image.asset('assets/images/icon1.png'))),
                          SizedBox(width: 20),
                          Text('Picture Perfect', style: titleTextStyle)
                        ]
                    ),
                    SizedBox(height: 100),
                    InputField( // Reusable Custom InputField
                      hintText: "Enter Your Name",
                      labelText: 'Name',
                      errorText: nameErrorText,
                      onChanged: (val){
                        name = val;
                      },
                    ),
                    InputField(
                      hintText: "Enter Your Phone Number",
                      labelText: 'Mobile Number',
                      errorText: numberErrorText,
                      onChanged: (val){
                        number = val;
                      },
                    ),
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
                    Button(
                      text: "Register",
                      onTap: ()async{
                        print(Platform.operatingSystem);
                        //TODO: form validation
                        setState(() {
                          emailErrorText = null;
                          passwordErrorText = null;
                          numberErrorText = null;
                          nameErrorText = null;
                          _load = true;
                        });
                        try { //  Form Validation
                          if(number.length != 10) {
                            numberErrorText = 'Enter a valid Number';
                            return;
                          }
                          if(name == ''){
                            nameErrorText = 'Enter a valid Name';
                            return;
                          }
                          final newUser = await _auth
                              .createUserWithEmailAndPassword(
                              email: email, password: password); // Creating User with email and password
                          await Firestore.instance.collection('users').document(email)
                              .setData({ 'email': email, 'number_verified' : false, 'number' : number, 'name' : name });
                          setState(() {
                            _load = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Feed()),
                          );
                        }catch(e){ // Checking for errors and corrections in User details
                          String emailMsg = null, passwordMsg = null;
                          if(e is PlatformException){
                            if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE'){ // Checking if email already registered
                              emailMsg = 'Email already registered';
                            }else if(e.code == 'ERROR_INVALID_EMAIL'){ //Checking if email entered is not in format
                              emailMsg = 'Invalid Email Address';
                            }else if(e.code == 'ERROR_WEAK_PASSWORD'){ // checking if password is weak
                              passwordMsg = 'Weak Password';
                            }
                          }
                          setState(() { // Updating respective fields with errors if found any
                            _load = false;
                            emailErrorText = email == '' ? 'Email must be filled'  :emailMsg;
                            passwordErrorText = password == '' ? 'Password must be filled' : passwordMsg;
                          });
                        }


                      },
                    ),
                    Button( // Link if user already exists
                      text: 'Already a User? Click Here to Login',
                      margin_vertical: 0,
                      font_size: 14,
                      text_color: Colors.blueAccent,
                      padding_vertical: 3,
                      padding_horizontal: 5,
                      background_color: Colors.transparent,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(child: loadingIndicator,alignment: FractionalOffset.center) // page progress loader
        ],
      ),
    );
  }
}
