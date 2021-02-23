import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:oauth/LoginPage/InputLogin.dart';

import 'Confirm.dart';
import '../Object/Global.dart';
import '../LoginPage/LoginPage.dart';

class InputSignUp extends StatefulWidget {
  final customFunction;
  InputSignUp({this.customFunction});
  @override
  _InputSignUpState createState() => _InputSignUpState();
}

class _InputSignUpState extends State<InputSignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: TextField(
            controller: username,
            decoration: InputDecoration(
                hintText: "Enter your username",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: TextField(
            controller: email,
            decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50, bottom: 10),
          height: 50.0,
          width: 200,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
            onPressed: () => signUp(context),
            padding: EdgeInsets.all(10.0),
            color: Colors.cyan,
            textColor: Colors.white,
            child: Text("Sign up", style: TextStyle(fontSize: 15)),
          ),
        ),
        Center(
          child: InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())),
            child: Text(
              "Do you already have an account? Login",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void signUp(context) async {
    final userAttributes = [
      new AttributeArg(name: 'email', value: email.text),
    ];

    var data;
    try {
      data = await Global.userPool.signUp(
        username.text,
        password.text,
        userAttributes: userAttributes,
      );

      Global.cognitoUser = new CognitoUser(username.text, Global.userPool);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Confirm(username.text)));
    } catch (e) {
      print(e);
    }
  }
}
