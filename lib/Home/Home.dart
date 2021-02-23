import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:oauth/Home/ChaletCard.dart';
import 'package:oauth/Object/Chalet.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'dart:convert';
import '../Object/Cart.dart';
import '../Object/Global.dart';
import '../Object/Session.dart';
import '../Drawer/PublicDrawer.dart';
import 'ChaletCard.dart';

var _items;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  double animHeight = 0;
  TextEditingController filter = TextEditingController();
  @override
  void initState() {
    super.initState();
    _items = getData();
    Cart.reset();
  }

  void searching() {
    setState(() {
      if (animHeight == 0)
        animHeight = 50;
      else if (animHeight == 50) animHeight = 0;
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.cyan[500],
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () => searching())
        ],
      ),
      drawer: PublicDrawer(),
      body: Center(
        child: Column(children: [
          AnimatedContainer(
            height: animHeight,
            duration: Duration(milliseconds: 500),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: filter,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15), hintText: " Cerca..."),
            ),
          ),
          Flexible(
            child: FutureBuilder(
                future: _items,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (filter.text.isEmpty)
                          return ChaletCard(snapshot.data[index], context);
                        else if (snapshot.data[index].name
                                .contains(filter.text) ||
                            snapshot.data[index].location.contains(filter.text))
                          return ChaletCard(snapshot.data[index], context);
                        else
                          return Container();
                      },
                      itemCount: snapshot.data.length,
                    );
                  } else
                    return Container(
                      child: CircularProgressIndicator(),
                      padding: EdgeInsets.only(top: 20),
                    );
                }),
          ),
        ]),
      ),
    );
  }

  Future getData() async {
    var idToken;
    if (Global.fbLogin == false)
      idToken = Session().session.getIdToken().getJwtToken();

    await Global.credentials.getAwsCredentials(idToken);
    const endpoint =
        'https://w1gcypmadi.execute-api.eu-central-1.amazonaws.com/get_all_chalets';
    final awsSigV4Client = new AwsSigV4Client(Global.credentials.accessKeyId,
        Global.credentials.secretAccessKey, endpoint,
        sessionToken: Global.credentials.sessionToken, region: 'eu-central-1');

    final signedRequest = new SigV4Request(
      awsSigV4Client,
      method: 'GET',
      path: '/get-all-chalets',
    );

    http.Response response;

    try {
      response =
          await http.get(signedRequest.url, headers: signedRequest.headers);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return await jsonResponse.map((e) => new Chalet.fromJson(e)).toList();
  }
}
