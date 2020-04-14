class Product {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;

  Product({this.id, this.name, this.description, this.price, this.imageUrl});
}

class Order {
  String id;
  List<Product> products;
  DateTime dateTime;
  double _amount;

  double get amount => _amount.toDouble();

  Order(this.id, this.products, this.dateTime) {
    _amount = 0;
    for (var p in products) {
      _amount += p.price;
    }
  }
}
