import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'helpers.dart';




class ImageGrid extends StatelessWidget {
  final Firestore firestore;
  final String email;
  ImageGrid({this.email, this.firestore});
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: firestore.collection('posts').where('email', isEqualTo: email).orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return Center(child: Text('No Photos'));
        final List<dynamic> docs = [];
        for(var doc in snapshot.data.documents){
          if(doc['email'] != email) break;
          docs.add(doc);
        }
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: docs.length,
            itemBuilder: (context, index){
              return GridItem(data: docs[index]['downloadUrl']);
            }
        );
      },
    );

  }
}

class GridItem extends StatelessWidget {
  final dynamic data;
  GridItem({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(5),
      child: Image.network(
        data,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress){
          if (loadingProgress == null) return child;
          return ShimmerLoader();
        },
      ),
    );
  }
}
