import 'dart:core';

import 'package:flutter/foundation.dart';

import '../models/Data.dart';

class FavoritesProvider with ChangeNotifier {
  final _items = <Product>[];

  List<Product> get items => [..._items];

  Product findFavoriteById(String id) {
    return _items.firstWhere((e) {
      return (e.id == id);
    }, orElse: () => null);
  }

  Product findProductById(String id) {
    return _items.firstWhere((e) {
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
}
