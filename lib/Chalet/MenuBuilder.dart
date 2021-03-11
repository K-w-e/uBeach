import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Object/Cart.dart';

class MenuBuilder extends StatelessWidget {
  var items;
  List cart;
  num totCart;

  ScrollController _scrollController = new ScrollController();

  Function() callback;

  MenuBuilder(this.items, this.cart, this.totCart, this.callback);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          num count = 0;
          if (Cart.item.contains(items[index]))
            for (int i = 0; i < Cart.item.length; i++)
              if (Cart.item[i] == items[index]) count++;
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  items[index]["image"],
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Icon(Icons.warning);
                  },
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(items[index]["name"]),
              subtitle:
                  Text("Costo: " + items[index]["price"].toString() + "€"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (count != 0) Text("x" + count.toString()),
                IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () => {addItem(items[index])}),
                IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () => {removeItem(items[index])}),
              ]),
              onLongPress: () => info(items[index], context),
            ),
          );
        });
  }

  void addItem(item) {
    Cart.item.add(item);
    callback();
  }

  void removeItem(item) {
    Cart.item.remove(item);
    callback();
  }

  Future<void> info(item, context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('${item["name"]}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Ingredienti: ${item["ingredients"]}'),
                  Text('Prezzo: ${item["price"]}\$'),
                ],
              ),
            ));
      },
    );
  }
}
