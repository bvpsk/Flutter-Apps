import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictureperfect/button.dart';
import 'package:pictureperfect/dialog.dart';
import 'package:pictureperfect/helpers.dart';
import 'package:pictureperfect/input_field.dart';
import 'package:pictureperfect/profile.dart';

import 'login.dart';

class Uploader extends StatefulWidget {

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  PickedFile pickedFile;
  String imageName = '', hashTags = '', email;
  FirebaseUser loggedInUser;
  ImageProvider _image = null;
  bool _load = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Firestore firestore = Firestore.instance;
  final picker = ImagePicker();

  void loadImage()async{
    pickedFile = await getImage(picker);
    setState(() {
      _image = FileImage(File(pickedFile.path));
    });
  }


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        email = user.email;
        final emailVerified = user.isEmailVerified;
        await firestore.collection('users')
            .document(email)
            .get()
            .then((DocumentSnapshot ds) {
          final numberVerified = ds.data['number_verified'];
          if(!numberVerified || !emailVerified){
              showDialog(context: context,
                barrierDismissible: false,
                builder: (context) => DialogBox(
                  title: 'Verify your details to Upload Photo',
                  buttonText: 'Verify',
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                )
              );
          }else{
            loadImage();
          }
        });
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState(){
//    loadImage();
    getCurrentUser();
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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()async{
                        await loadImage();
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          child: _image == null ? Image.asset('assets/images/blank-profile-picture.png') : Image(image: _image, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InputField(
                              marginVertical: 20,
                              labelText: 'Name',
                              helperText: 'Name of the Image',
                              onChanged: (val){
                                imageName = val;
                              },
                            ),
                            InputField(
                              labelText: 'Hashtag',
                              helperText: 'hashtag for the Image',
                              onChanged: (val){
                                hashTags = val;
                              },
                            ),
                            Button(
                              text: 'Upload',
                              font_size: 18,
                              onTap: ()async{
                                setState(() {
                                  _load = true;
                                });
                                String downloadUrl = await uploadImage(pickedFile, storage);
                                await firestore.collection('posts').document()
                                    .setData({
                                  'email': email,
                                  'name': imageName,
                                  'hashtags': hashTags,
                                  'date': DateTime.now().toUtc().millisecondsSinceEpoch,
                                  'downloadUrl': downloadUrl
                                });
                                setState(() {
                                  _load = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Profile()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(child: loadingIndicator,alignment: FractionalOffset.center)
        ],
      )
    );
  }
}
