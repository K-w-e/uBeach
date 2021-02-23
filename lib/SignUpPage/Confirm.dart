import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import '../Object/Global.dart';

class Confirm extends StatelessWidget {
  final String username;
  Confirm(this.username);

  TextEditingController sms = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.cyan[500],
      ),
      body: Center(
          child: Column(
        children: [
          Text("Username: " + username),
          TextField(controller: sms),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.cyan[500],
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: InkWell(
                onTap: () => confirm(context),
                child: Text(
                  "Confirm!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
                color: Colors.cyan[500],
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: InkWell(
                onTap: () => resend(),
                child: Text(
                  "Resend code!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void confirm(context) async {
    bool registrationConfirmed = false;

    try {
      registrationConfirmed =
          await Global.cognitoUser.confirmRegistration(sms.text);
    } catch (e) {
      print(e);
    }
    if (registrationConfirmed == true)
      Navigator.popUntil(context, ModalRoute.withName('/'));
    else
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Errore! Codice sbagliato!')));
  }
}

void resend() async {
  try {
    await Global.cognitoUser.resendConfirmationCode();
  } catch (e) {
    print(e);
  }
}
