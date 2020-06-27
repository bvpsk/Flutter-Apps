
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pictureperfect/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pictureperfect/login.dart';
import 'package:pictureperfect/helpers.dart';
import 'package:pictureperfect/dialog.dart';
import 'package:pictureperfect/add_image.dart';

import 'feed.dart';
import 'image_grid.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
  bool _load = false, _profileLoad = false, numberVerified = false, emailVerified = false;
  ImageProvider _image = null;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String email, mobileNumber, name;
  Timer _timer, timer;
  final _codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
    Future(() async { // Checking periodically the status of email and phone verification
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser()..reload();
        var user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          setState((){
            emailVerified = user.isEmailVerified;
          });
          timer.cancel();
        }
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();

  }


  Future getUserGallery()async{
      var snapshots = firestore.collection('posts').where('email', isEqualTo: email)
          .snapshots();
      print(snapshots);
      print(await snapshots.length);
  }

  void getCurrentUser() async { // Asynchronously getting the details of logged in user
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        email = user.email;
        emailVerified = user.isEmailVerified;
        await firestore.collection('users')
            .document(email)
            .get()
            .then((DocumentSnapshot ds) {
          numberVerified = ds.data['number_verified'];
          mobileNumber = ds.data['number'];
          name = ds.data['name'];
        });
        getProfilePic();
//        getUserGallery();
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()), // if no user is logged, the page is redirected to login page
        );
      }
    } catch (e) {
      print(e);
    }
  }



  Future getProfilePic()async{ // Getting the profile picture
    setState(() {
      _profileLoad = true;
    });
    await firestore.collection('users')
        .document(email)
        .get()
        .then((DocumentSnapshot ds) {
          String profileUrl = ds.data['profile_url'];
          setState(() {
            _image = profileUrl == null ? null : NetworkImage(profileUrl);
            _profileLoad = false;

          });
    });
  }

  Future setProfilePic()async{ //Updating the Profile picture of the user
    setState(() {
      _profileLoad = true;
    });
    PickedFile img_file = await getImage(picker);
    String downloadUrl = await uploadImage(img_file, storage);
    if(downloadUrl != null) {
      await firestore.collection('users').document(email).updateData(
          {'profile_url': downloadUrl});
      setState(() {
        _image = FileImage(File(img_file.path));
        _profileLoad = false;
      });
    }
  }

  Future registerUser(String mobile, BuildContext context) async{ // making phone number verification and linking credentials with email credentials

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: '+91${mobile}',
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential)async{
          print('Auth completed');
          await firestore.collection('users').document(email).updateData(
              {'number_verified': true});
          setState(() {
            numberVerified = true;
          });
        },
        verificationFailed: (AuthException authException){
          print('Auth verification error');
          print(authException.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          //show dialog to take input from the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DialogBox(
                title: 'Enter Code',
                textController: _codeController,
                onPressed: () {
                  String smsCode = _codeController.text.trim();
                  var _credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
                  loggedInUser.linkWithCredential(_credential).then((AuthResult result)async{
                    await firestore.collection('users').document(email).updateData(
                        {'number_verified': true});
                    setState(() {
                      numberVerified = true;
                    });

                  }).catchError((e){
                    print(e);
                  });
                  Navigator.pop(context);
                },
              )
          );

        },
        codeAutoRetrievalTimeout: null
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator =_load ? new Container(
      color: Colors.grey.withOpacity(0.3),
      child: Center(child: Container(
          width: 75,
          height: 75,
          child: CircularProgressIndicator())),
    ):new Container();

    Widget profileIndicator =_profileLoad ? new Container( // Profile loading Progress Indicator
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(100),
        color: Colors.grey.withOpacity(0.3),
      ),

      child: Center(child: Container(

          width: 75,
          height: 75,
          child: CircularProgressIndicator())),
    ):new Container();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Uploader()),
          );
        },
      ),
      body: Builder(
        builder: (BuildContext context){
          return Stack(
            children: <Widget>[
              //SingleChildScrollView
              SafeArea(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          CircleAvatar( // User Profile Picture
//                          child: Image.asset('assets/images/blank-profile-picture.png'),
                            child: Align(child: profileIndicator,alignment: FractionalOffset.center),
                            radius: 60,
                            backgroundImage: _image ?? AssetImage('assets/images/blank-profile-picture.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text( // Profile User Name
                                  name??'User Name',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent
                                  ),
                                ),
                                IconButton( // User Name Changing Button
                                  icon: Icon(Icons.mode_edit),
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => DialogBox(
                                          title: 'Enter Name',
                                          textController: _codeController,
                                          onPressed: ()async{
                                            String newName = _codeController.text;
                                            await firestore.collection('users').document(email).updateData(
                                                {'name': newName}).then((val){
                                                  setState(() {
                                                    name = newName;
                                                  });
                                            });
                                            Navigator.pop(context);
                                          },
                                        )
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Button( // Button to select new pic and change profile pic
                            text: 'Change Profile pic',
                            font_size: 13,
                            padding_horizontal: 10,
                            padding_vertical: 4,
                            margin_vertical: 0,
                            background_color: Colors.blueGrey,
                            onTap: ()async{
                              await setProfilePic();
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Button( // Email Verification Status and Update Button
                              text: emailVerified ? "Email Verified" : 'Verify Email',
                              font_size: 17,
                              padding_vertical: 10,
                              margin_horizontal: 10,
                              margin_vertical: 10,
                              background_color: emailVerified ? Colors.greenAccent : Colors.redAccent,
                              onTap: emailVerified ? null : ()async{
                                final snackbar = SnackBar(
                                  content: Text("Verification Email sent. check your mail!!!"),
                                );
                                await loggedInUser.sendEmailVerification().then((val){
                                  Scaffold.of(context).showSnackBar(snackbar);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Button( // Phone Verification Status and Update Button
                              margin_vertical: 10,
                              margin_horizontal: 10,
                              text: numberVerified ? "Number Verified" : 'Verify Number',
                              font_size: 17,
                              padding_horizontal: 10,
                              padding_vertical: 10,
                              background_color: numberVerified ? Colors.greenAccent : Colors.redAccent,
                              onTap: numberVerified ? null : ()async{
                                final snackbar = SnackBar(
                                  content: Text("Number verification is in progress"),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                                await registerUser(mobileNumber, context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column( // User's personal Gallery
                        children: <Widget>[
                          Text('Your Pictures',
                            style: TextStyle(fontSize: 22),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            height: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      Expanded(child: ImageGrid(email: email, firestore: firestore)) // Image Grid to display user's images
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.all(10),
                      child: IconButton(
                        icon: Icon(Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        iconSize: 40,
                        onPressed: ()async{
                          await _auth.signOut();
                          _timer.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn()),
                          );
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.rss_feed,
                            color: Colors.black,
                          ),
                          iconSize: 40,
                          onPressed: ()async{
                            _timer.cancel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Feed()),
                            );
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Align(child: loadingIndicator,alignment: FractionalOffset.center)
            ],
          );
        }
      ),
    );
  }
}






