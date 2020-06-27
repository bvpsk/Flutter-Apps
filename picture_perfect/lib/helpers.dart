import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Future getImage(picker) async {
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
//  print(pickedFile.path);
  return pickedFile;
}


Future<String> uploadImage(PickedFile pickedFile, FirebaseStorage storage) async {
  String path = pickedFile.path;
  String imageName = path
      .substring(path.lastIndexOf("/"), path.lastIndexOf("."))
      .replaceAll("/", "");
  final Directory systemTempDir = Directory.systemTemp;
  final byteData = await pickedFile.readAsBytes();
  final file =
  File('${systemTempDir.path}/$imageName.jpeg');
  await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes, byteData.lengthInBytes));
  StorageTaskSnapshot snapshot = await storage
      .ref()
      .child("images/$imageName")
      .putFile(file)
      .onComplete;
  if (snapshot.error == null) {
    final String downloadUrl =
    await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  return null;
}

class ShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                  color: Colors.white
              ),
            ),
          ],
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]
    );
  }
}