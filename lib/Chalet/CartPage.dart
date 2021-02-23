import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Object/Cart.dart';
import '../Object/Chalet.dart';
import '../Object/Global.dart';
import '../Object/Session.dart';

class CartPage extends StatefulWidget {
  Chalet chalet;
  Function callback;
  CartPage(this.chalet, this.callback);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  num tot = 0;

  @override
  Widget build(BuildContext context) {
    tot = 0;
    for (var x in Cart.item) tot += x['price'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrello"),
        backgroundColor: Colors.cyan[500],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Cart.item.length,
                itemBuilder: (context, index) {
                  if (Cart.item.length == 0)
                    return Center(
                      child: Text("Il carrello è vuoto!"),
                    );
                  else
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          Cart.item[index]["image"],
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      title: Text('${Cart.item[index]["name"]}'),
                      subtitle:
                          Text('${Cart.item[index]["price"].toString()}\$'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_outlined),
                        onPressed: () => remove(index),
                      ),
                    );
                },
              ),
            ),
            ListTile(
              title: Text("Totale"),
              trailing: Text(tot.toString() + "\$"),
            ),
            Divider(
              thickness: 2,
            ),
            InkWell(
              onTap: () => send(),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: Colors.cyan[500],
                    borderRadius: BorderRadius.all(Radius.circular(50.0))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Conferma ordine ~ ${tot}\$",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void send() async {
    var email;
    if (Global.fbLogin == false) {
      var attributes = await Global.cognitoUser.getUserAttributes();
      attributes.forEach((attribute) {
        if (attribute.getName() == 'email') email = attribute.getValue();
      });
    } else if (Global.fbLogin == true) {
      email = Global.fbProfile['email'];
    }

    var idToken;
    if (Global.fbLogin == false) Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);
    const endpoint =
        'https://8xvvt9vqd1.execute-api.eu-central-1.amazonaws.com/email_sender';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');
    List cart = [];
    for (var x in Cart.item) cart.add(x["name"]);
    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/send-email',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/json; charset=utf-8'}),
        body: new Map<String, dynamic>.from({
          'email': email,
          'cart': cart,
          'tot': tot.toString() + "€",
          'chalet': widget.chalet.name,
          'id_chalet': widget.chalet.id
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

  remove(index) {
    Cart.item.removeAt(index);
    setState(() {});
    widget.callback();
  }
}
