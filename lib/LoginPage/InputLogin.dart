import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:oauth/Object/Session.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import '../SignUpPage/SignUpPage.dart';
import '../Object/Global.dart';
import '../Home/Home.dart';

class InputLogin extends StatefulWidget {
  final customFunction;
  InputLogin({this.customFunction});
  @override
  _InputLoginState createState() => _InputLoginState();
}

class _InputLoginState extends State<InputLogin> {
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
          margin: EdgeInsets.only(top: 50, bottom: 10),
          height: 50.0,
          width: 200,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
            onPressed: () => login(context),
            padding: EdgeInsets.all(10.0),
            color: Colors.cyan,
            textColor: Colors.white,
            child: Text("Login", style: TextStyle(fontSize: 15)),
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
            onPressed: () => fb(),
            padding: EdgeInsets.all(10.0),
            color: Colors.cyan,
            textColor: Colors.white,
            child: Text("Login with Facebook", style: TextStyle(fontSize: 15)),
          ),
        ),
        Center(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            ),
            child: Text(
              "Need an account? Sign up",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void fb() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    //final result = await facebookLogin.logInWithReadPermissions(['email']);
    Global.fbAccessToken = result.accessToken.token;

    await Global.credentials
        .getAwsCredentials(result.accessToken.token, 'graph.facebook.com');
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Global.fbLogin = true;
        Global.fbProfile = json.decode(graphResponse.body);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        break;
      case FacebookLoginStatus.cancelledByUser:
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Qualcosa è andato storto!"),
          backgroundColor: Colors.red,
        ));
        break;
      case FacebookLoginStatus.error:
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Qualcosa è andato storto!"),
          backgroundColor: Colors.red,
        ));
        break;
    }
  }

  void login(context) async {
    Global.cognitoUser = new CognitoUser(username.text, Global.userPool);
    final param = [
      new AttributeArg(name: 'email', value: email.text),
    ];
    final authDetails = new AuthenticationDetails(
        username: username.text,
        password: password.text,
        authParameters: param);
    try {
      Session(session: await Global.cognitoUser.authenticateUser(authDetails));
      Global.fbLogin = false;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Incorrect username or password!"),
        backgroundColor: Colors.red,
      ));
      username.clear();
      password.clear();
    } catch (e) {
      print(e);
    }
  }
}
