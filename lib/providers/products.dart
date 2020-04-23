import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/products.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider(
      {this.userId = "", this.authToken = "", items = const <Product>[]})
      : _items = items {
    client = ProductsHttpClient(userId: userId, token: authToken);
  }

  var _items = <Product>[];
  final String authToken;
  final String userId;

  List<Product> get products => [..._items];
  ProductsHttpClient client;

  Future<Product> findProductById(String id) async {
    final index = _items.indexWhere((e) {
      return (e.id == id);
    });
    try {
      _items[index] = await client.getProduct(id);
      notifyListeners();
      return _items[index];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> fetch({bool filter = false}) async {
    try {
      _items = await client.getAll(filterByUid: filter);
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    try {
      p.userId = userId;
      await client.addProduct(p);
      _items.add(p);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> editProduct(Product p) async {
    try {
      await client.editProduct(p);
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
      await client.deleteProduct(productId);
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
