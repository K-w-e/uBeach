class Chalet {
  final String id, name, description, location, image, item;
  // final List menu;
  final List primi, secondi, bar, bibite;

  Chalet(
      {this.name,
      this.description,
      this.id,
      this.location,
      this.image,
      this.primi,
      this.secondi,
      this.bar,
      this.bibite,
      // this.menu,
      this.item});

  factory Chalet.fromJson(Map<String, dynamic> json) {
    return Chalet(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        location: json['location'],
        image: json['image'],
        item: json['item'],
        //   menu: json['primi'],
        primi: json['primi'],
        secondi: json['secondi'],
        bar: json['bar'],
        bibite: json['bibite']);
  }
}
