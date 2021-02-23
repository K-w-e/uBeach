class Order {
  final List cart;
  final String id, tot, title;
  Order({this.tot, this.cart, this.id, this.title});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['item'],
        cart: json['cart'],
        tot: json['tot'],
        title: json['title']);
  }
}
