import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[500],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Ordine completato!",
                style: TextStyle(fontSize: 34),
              ),
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.shopping_bag_outlined,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "A breve riceverai una notifica con le informazioni dell'ordine",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      num count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                          color: Colors.cyan[500],
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Torna allo chalet",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
