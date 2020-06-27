import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pictureperfect/profile.dart';

import 'add_image.dart';
import 'constants.dart';
import 'helpers.dart';
import 'login.dart';
class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _load = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String email;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        email = user.email;
      } else {
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
  Widget build(BuildContext context) {
    Widget loadingIndicator =_load ? new Container(
      color: Colors.grey.withOpacity(0.3),
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
      body: Stack(
        children: <Widget>[

          SafeArea(
            child: Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('posts').snapshots(),
                  builder: (context, snapshot){
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      );
                    }
                    final docs = snapshot.data.documents;
                    List<Post> posts = [];
                    for(var doc in docs){
                      final data = doc.data;
                      posts.add(Post(
                        downloadUrl: data['downloadUrl'],
                        hashtags: data['hashtags'],
                        name: data['name'],
                        date: data['date'],
                        email: data['email'],
                      ));
                    }

                    return Expanded(
                      child: ListView(
//                        reverse: true,
                        children: posts,
                      ),
                    );
                  },
                ),
              ],
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
                      icon: Icon(Icons.account_circle,
                        color: Colors.greenAccent,
                      ),
                      iconSize: 40,
                      onPressed: ()async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          Align(child: loadingIndicator,alignment: FractionalOffset.center)
        ],
      ),
    );
  }
}

class Post extends StatelessWidget {

  final String downloadUrl, hashtags, name, email;
  final int date;
  DateTime dateTime;

  Post({this.downloadUrl, this.hashtags, this.name, this.date, this.email}){
    dateTime = DateTime.fromMillisecondsSinceEpoch(date, isUtc: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10)
      ),

      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(email,
            style: kFeedTextStyle,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                downloadUrl,
                fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress){
              if (loadingProgress == null) return child;
              return ShimmerLoader();
            }

              ),
            ),
          ),
          Text(name, style: kFeedTextStyle.copyWith(color: Colors.brown)),
          Text(hashtags, style: kFeedTextStyle.copyWith(color: Colors.pinkAccent, fontSize: 17)),
          Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
              style: kFeedTextStyle.copyWith(color: Colors.black87, fontSize: 15)),
        ],
      ),
    );
  }
}

