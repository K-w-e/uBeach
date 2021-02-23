import 'package:flutter/material.dart';
import '../Object/Order.dart';

class GetOrders extends StatelessWidget {
  List orders;
  GetOrders(this.orders);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Check your orders!'),
          backgroundColor: Colors.cyan[500],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ExpansionTile(
                title: Text(
                  orders[index].title,
                ),
                expandedAlignment: Alignment.bottomLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                childrenPadding: EdgeInsets.all(15),
                children: [
                  InsideOrder(orders[index], index),
                ],
              ));
            }));
  }
}

class InsideOrder extends StatelessWidget {
  Order order;
  int index;
  InsideOrder(this.order, this.index);
  @override
  Widget build(BuildContext context) {
    String cart = "";
    for (var i = 0; i < order.cart.length; i++) {
      cart += order.cart[i].toString() + ", ";
    }
    cart = cart.substring(0, cart.length - 2);
    return Text(cart + "  ~  " + order.tot);
  }
}
