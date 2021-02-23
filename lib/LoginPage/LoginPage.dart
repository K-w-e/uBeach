import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Header.dart';
import 'InputWrapper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
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
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.cyan[500],
          Colors.cyan[300],
          Colors.cyan[400]
        ])),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Header(),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60))),
              child: SingleChildScrollView(child: InputWrapper()),
            ))
          ],
        ),
      ),
    );
  }
}
