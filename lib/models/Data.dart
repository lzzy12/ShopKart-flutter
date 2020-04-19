import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.imageUrl});

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    price = map['price'];
    imageUrl = map['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}

class Order {
  String id;
  List<Product> products;
  DateTime dateTime;

  double get amount => _getAmount();

  double _getAmount() {
    var _amount = 0.0;
    for (var p in products) {
      _amount += p.price;
    }
    return _amount;
  }

  Order(this.id, this.products, this.dateTime);

  Map<String, dynamic> toMap() {
    final ids = <String>[];
    products.forEach((e) => ids.add(e.id));
    return {
      'id': id,
      'products': ids,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  Order.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        dateTime = map['dateTime'],
        products = map['products'];

  String toJson() => json.encode(toMap());
}
