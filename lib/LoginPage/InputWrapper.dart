import 'package:flutter/material.dart';
import 'InputLogin.dart';

class InputWrapper extends StatefulWidget {
  String username, password, email;
  InputWrapper({this.username, this.password, this.email});

  @override
  _InputWrapperState createState() => _InputWrapperState();

  _InputWrapperState of(BuildContext context) =>
      context.findAncestorStateOfType();
}

class _InputWrapperState extends State<InputWrapper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InputLogin(),
          ),
        ],
      ),
    );
  }
}
