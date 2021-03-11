class Order {
  final List cart;
  final String id, tot, title, chalet;
  Order({this.tot, this.cart, this.id, this.title, this.chalet});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['item'],
        cart: json['cart'],
        tot: json['tot'],
        title: json['title'],
        chalet: json['chalet']);
  }
}
