import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Data.dart';

class CartProvider with ChangeNotifier {
  var _items = <Product>[];

  List<Product> get items => [..._items];

  double get amount => getTotalAmount();

  void addProduct(Product p) {
    _items.add(p);
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((e) {
      return productId == e.id;
    });
    notifyListeners();
  }

  Future<void> checkout() async {
    _items = <Product>[];
    notifyListeners();
  }

  int getQuantity(String productId) {
    return _items.where((e) {
      return (e.id == productId);
    }).length;
  }

  double getTotalAmount() {
    double r = 0;
    for (var i in _items) {
      r += i.price;
    }
    return r;
  }
}
