import 'dart:core';

import 'package:flutter/foundation.dart';

import '../models/Data.dart';

class FavoritesProvider with ChangeNotifier {
  final _items = <Product>[];

  List<Product> get items => [..._items];

  Product findFavoriteById(String id) {
    return _items.firstWhere((e) {
      if (e.id == id) return true;
      return false;
    }, orElse: () => null);
  }

  Product findProductById(String id) {
    return _dummy.firstWhere((e) {
      if (e.id == id) return true;
      return false;
    }, orElse: () => null);
  }

  bool isFavorite(String productId) {
    return (findFavoriteById(productId) != null);
  }

  void toggleFavorite(String productId) {
    final favoriteProduct = findFavoriteById(productId);
    if (favoriteProduct != null) {
      _items.removeWhere((e) {
        if (e.id == productId) return true;
        return false;
      });
    } else {
      _items.add(findProductById(productId));
    }
    notifyListeners();
  }

  static final _dummy = [
    Product(
      id: 'p1',
      name: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      name: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      name: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      name: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
}
