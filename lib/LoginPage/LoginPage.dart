import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Header.dart';
import 'InputWrapper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.title});
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: _screenSize.height,
        width: _screenSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.cyan[500], Colors.cyan[300], Colors.cyan[400]],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: [
              Header(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(child: InputWrapper()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
