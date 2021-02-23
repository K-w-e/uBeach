import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:oauth/Object/Session.dart';
import '../Home/Home.dart';
import 'InputLogin.dart';
import '../Object/Global.dart';

class Button extends StatelessWidget {
  final String username, password, email;
  Button({this.username, this.password, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: Colors.cyan[500], borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: InkWell(
          onTap: () => login(context),
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void login(context) async {
    Global.cognitoUser = new CognitoUser(username, Global.userPool);
    var us = username;
    var pw = password;
    final param = [
      new AttributeArg(name: 'email', value: email),
    ];
    final authDetails = new AuthenticationDetails(
        username: us, password: pw, authParameters: param);
    try {
      Session(session: await Global.cognitoUser.authenticateUser(authDetails));

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
    } catch (e) {
      print(e);
    }
  }
}
