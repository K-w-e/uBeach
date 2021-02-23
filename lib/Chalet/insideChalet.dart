import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/rendering.dart';
import 'package:oauth/Chalet/MenuChoiceBox.dart';
import 'package:oauth/Chalet/MenuBuilder.dart';
import '../Object/Cart.dart';
import '../Object/Chalet.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import '../Object/Global.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import '../Object/Session.dart';
import 'CartPage.dart';

class insideChalet extends StatefulWidget {
  Chalet chalet;
  insideChalet(this.chalet);

  @override
  _ChaletState createState() => _ChaletState();
}

class _ChaletState extends State<insideChalet> {
  String type = "Primi";
  List cart;
  num totCart;

  @override
  Widget build(BuildContext context) {
    List menu = ["Primi", "Secondi", "Bar", "Bibite"];
    setState(() {});
    return WillPopScope(
      onWillPop: () {
        Cart.reset();
        Navigator.pop(context);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.cyan,
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.chalet.name),
                background: Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    widget.chalet.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.chalet.description),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [Icon(Icons.map), Text(widget.chalet.location)],
                ),
              ),
              Container(
                width: 300,
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemCount: menu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ChoiceBox(menu[index], setType),
                    );
                  },
                ),
              ),
              if (type == "Primi")
                MenuBuilder(widget.chalet.primi, cart, totCart, update),
              if (type == "Secondi")
                MenuBuilder(widget.chalet.secondi, cart, totCart, update),
              if (type == "Bar")
                MenuBuilder(widget.chalet.bar, cart, totCart, update),
              if (type == "Bibite")
                MenuBuilder(widget.chalet.bibite, cart, totCart, update),
            ]))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CartPage(widget.chalet, update))),
          child: Badge(
            badgeContent: Text(Cart.item.length.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: null,
            ),
          ),
        ),
      ),
    );
  }

  update() {
    setState(() {});
  }

  setType(string) {
    setState(() {
      type = string;
    });
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
        'https://sz3fa273wd.execute-api.eu-central-1.amazonaws.com/add_order';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: '/add-order',
        headers: new Map<String, String>.from(
            {'Content-Type': 'application/json; charset=utf-8'}),
        body: new Map<String, dynamic>.from({
          'id_user': Global.credentials.userIdentityId,
          'email': email,
          'cart': cart,
          'tot': totCart.toString() + "€",
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
    print(response.body);
  }
}
