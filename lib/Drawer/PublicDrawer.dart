import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'EditAccount.dart';
import 'GetOrders.dart';
import '../Object/Global.dart';
import '../Object/Order.dart';
import '../Object/Session.dart';

class PublicDrawer extends StatefulWidget {
  PublicDrawer({Key key}) : super(key: key);

  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Visualizza ordini'),
              onTap: () {
                getOrder();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Gestione account'),
              onTap: () {
                editAccount();
              },
            ),
            Divider(
              color: Colors.black,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),
            /*ListTile(
              leading: Icon(Icons.note_add),
              title: Text('*** Add item ***'),
              onTap: () {
                addItem();
              },
            ),*/
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  logout();
                }),
          ],
        ),
      ),
    );
  }

  void addItem() async {
    var idToken;
    if (Global.fbLogin == false)
      idToken = Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);

    const endpoint =
        'https://0j5ikgxu98.execute-api.eu-central-1.amazonaws.com/add_chalet';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/add-chalet',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/json; charset=utf-8'}),
        body: new Map<String, dynamic>.from({
          'name': 'Chalet Nuovo',
          'description': 'Nuova descrizione di prova',
          'location': 'Milano, Via brecce 126',
          'image': 'https://ubeach.s3.eu-central-1.amazonaws.com/3.jpg',
        }));

    http.Response response;
    try {
      response = await http.post(
        signedRequest.url,
        headers: signedRequest.headers,
        body: signedRequest.body,
      );
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    if (Global.fbLogin == false) {
      Global.credentials.resetAwsCredentials();
      Global.cognitoUser.globalSignOut();
    } else if (Global.fbLogin == true) Global.fbProfile = null;
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void editAccount() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => EditAccount()));
  }

  void getOrder() async {
    var idToken;
    if (Global.fbLogin == false) Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);
    const endpoint =
        'https://6a0t7a3kh9.execute-api.eu-central-1.amazonaws.com/orders';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/get-orders',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/json; charset=utf-8'}),
        body: new Map<String, dynamic>.from(
            {'id': Global.credentials.userIdentityId, 'object': 'user'}));

    http.Response response;
    try {
      response = await http.post(
        signedRequest.url,
        headers: signedRequest.headers,
        body: signedRequest.body,
      );
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    var orders = await jsonResponse.map((e) => new Order.fromJson(e)).toList();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => GetOrders(orders)));
  }

  void getOrderFb() async {
    var idToken;
    if (Global.fbLogin == false)
      idToken = Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);
    const endpoint =
        'https://6a0t7a3kh9.execute-api.eu-central-1.amazonaws.com/orders';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/get-orders',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/json; charset=utf-8'}),
        body: new Map<String, dynamic>.from(
            {'id': Global.credentials.userIdentityId, 'object': 'user'}));

    http.Response response;
    try {
      response = await http.post(
        signedRequest.url,
        headers: signedRequest.headers,
        body: signedRequest.body,
      );
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    var orders = await jsonResponse.map((e) => new Order.fromJson(e)).toList();
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => GetOrders(orders)));
  }
}
