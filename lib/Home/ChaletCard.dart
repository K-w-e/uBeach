import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Object/Global.dart';
import '../Object/Chalet.dart';
import '../Object/Session.dart';
import '../Chalet/insideChalet.dart';

class ChaletCard extends StatelessWidget {
  BuildContext context;
  var chalet;

  ChaletCard(this.chalet, this.context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(chalet.image))),
          child: ListTile(
              contentPadding: EdgeInsets.only(top: 150),
              title: Center(
                child: Text(
                  chalet.name,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.cyan,
                      backgroundColor: Colors.black.withOpacity(0.5)),
                ),
              )),
        ),
        onTap: () {
          getChaletInfo(chalet.id, chalet.item);
        });
  }

  Future getChaletInfo(id, item) async {
    var idToken;
    if (Global.fbLogin == false)
      idToken = Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://jg3urfxts9.execute-api.eu-central-1.amazonaws.com/chalet_info';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/get-chalet-info',
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: {'id': id, 'item': item});

    http.Response response;

    try {
      response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    Chalet chalet = Chalet.fromJson(jsonResponse);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => insideChalet(chalet)));
  }
}
