import 'package:flutter/material.dart';

class ChoiceBox extends StatelessWidget {
  var text;
  Function(String) callback;
  ChoiceBox(this.text, this.callback);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.cyan,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
      onPressed: () => test(),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  test() {
    String newType = text;
    callback(newType);
  }
}
