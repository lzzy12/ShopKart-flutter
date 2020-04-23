import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Product {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  String userId;

  Product(
      {@required this.name,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.userId})
      : id = Uuid().v4();

  Product.fromMap(Map<String, dynamic> map) {
    if (map['id'] != null)
      id = map['id'];
    else
      id = Uuid().v4();
    name = map['name'];
    description = map['description'];
    price = map['price'];
    imageUrl = map['imageUrl'];
    userId = map['userId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
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

  Order(this.products, this.dateTime, {String id}) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    final ids = <String>[];
    products.forEach((e) => ids.add(e.id));
    return {
      'id': id,
      'products': ids,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  Order.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? Uuid().v4();
    dateTime = map['dateTime'];
    products = map['products'];
  }

  String toJson() => json.encode(toMap());
}
