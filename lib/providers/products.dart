import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/products.dart';

class ProductsProvider with ChangeNotifier {
  var _items = <Product>[];

  List<Product> get products => [..._items];
  final _client = ProductsHttpClient();

  Future<Product> findProductById(String id) async {
    final index = _items.indexWhere((e) {
      return (e.id == id);
    });
    try {
      _items[index] = await _client.getProduct(id);
      notifyListeners();
      return _items[index];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> fetch() async {
    _items = await _client.getAll();
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    try {
      final res = await _client.addProduct(p);
      p.id = json.decode(res.body)['name'];
      _items.add(p);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> editProduct(Product p) async {
    try {
      await _client.editProduct(p);
      final i = _items.indexWhere((e) {
        return (e.id == p.id);
      });
      _items[i] = p;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _client.deleteProduct(productId);
      final i = _items.indexWhere((e) {
        return (e.id == productId);
      });
      _items.removeAt(i);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
