import 'package:flutter/material.dart';
import 'LoginPage/LoginPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.cyan[500],
      ),
      home: LoginPage(title: 'uBeach'),
    );
  }
}
