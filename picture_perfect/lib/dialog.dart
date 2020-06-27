import 'package:flutter/material.dart';


class DialogBox extends StatelessWidget {
  final textController;
  final String title, buttonText;
  final Function onPressed;

  DialogBox({this.title = 'Enter Text', this.buttonText = 'Done', this.onPressed, this.textController});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            this.textController != null ? TextField(
              controller: textController,
            ) : Container(),

          ],
        ),
        actions: [
          FlatButton(
            child: Text(buttonText),
            textColor: Colors.white,
            color: Colors.blueAccent,
            onPressed: onPressed ?? (){Navigator.pop(context);},
          )
        ]
    );
  }
}
