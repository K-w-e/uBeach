import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import '../Object/Global.dart';

class EditAccount extends StatelessWidget {
  TextEditingController oldPsw = new TextEditingController();
  TextEditingController newPsw = new TextEditingController();
  TextEditingController email = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your account!'),
          backgroundColor: Colors.cyan[500],
        ),
        body: Builder(
          builder: (BuildContext context) {
            if (Global.fbLogin == false) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text("Nome account: " + Global.cognitoUser.username),
                    TextField(
                        obscureText: true,
                        controller: oldPsw,
                        decoration:
                            InputDecoration(hintText: 'Enter old password')),
                    TextField(
                        obscureText: true,
                        controller: newPsw,
                        decoration:
                            InputDecoration(hintText: 'Enter new password')),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color.fromRGBO(0, 160, 227, 1))),
                      onPressed: () => editPassword(),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.cyan,
                      textColor: Colors.white,
                      child: Text("Update your password",
                          style: TextStyle(fontSize: 15)),
                    ),
                    TextField(
                        controller: email,
                        decoration:
                            InputDecoration(hintText: 'Enter new email')),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Color.fromRGBO(0, 160, 227, 1))),
                      onPressed: () => editEmail(),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.cyan,
                      textColor: Colors.white,
                      child: Text("Update your email",
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              );
            } else
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                          "Hai effettuato il login con Facebook!\nNon puoi modificare i dati del tuo account!\n"),
                      Text(Global.fbProfile['name']),
                      Text(Global.fbProfile['email']),
                      Text(Global.fbProfile['id']),
                      Image.network(
                          "https://graph.facebook.com/${Global.fbProfile['id']}/picture?type=normal&access_token=${Global.fbAccessToken}"),
                    ],
                  ),
                ),
              );
          },
        ));
  }

  void editPassword() async {
    bool passwordChanged = false;
    try {
      passwordChanged = await Global.cognitoUser.changePassword(
        oldPsw.text,
        newPsw.text,
      );
    } catch (e) {
      print(e);
    }
    print(passwordChanged);
  }

  void editEmail() async {
    final List<CognitoUserAttribute> attributes = [];
    attributes.add(new CognitoUserAttribute(name: 'email', value: email.text));

    try {
      await Global.cognitoUser.updateAttributes(attributes);
    } catch (e) {
      print(e);
    }
  }
}
