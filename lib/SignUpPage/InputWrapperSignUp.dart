import 'package:flutter/material.dart';
import '../LoginPage/Button.dart';
import '../LoginPage/InputLogin.dart';
import 'InputSignUp.dart';

class InputWrapperSignUp extends StatefulWidget {
  String username, password, email;
  InputWrapperSignUp({this.username, this.password, this.email});

  @override
  _InputWrapperSignUpState createState() => _InputWrapperSignUpState();

  _InputWrapperSignUpState of(BuildContext context) =>
      context.findAncestorStateOfType();
}

class _InputWrapperSignUpState extends State<InputWrapperSignUp> {
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
            child: InputSignUp(),
          ),
          //Button()
        ],
      ),
    );
  }
}
